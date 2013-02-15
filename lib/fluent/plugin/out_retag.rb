class Fluent::RetagOutput < Fluent::Output
  Fluent::Plugin.register_output('retag', self)

  config_param :tag, :string, :default => nil
  config_param :remove_prefix, :string, :default => nil
  config_param :add_prefix, :string, :default => nil

  def configure(conf)
    super
    if not @tag and not @remove_prefix and not @add_prefix
      raise Fluent::ConfigError, "missing both of remove_prefix and add_prefix"
    end
    if @tag and (@remove_prefix or @add_prefix)
      raise Fluent::ConfigError, "both of tag and remove_prefix/add_prefix must not be specified"
    end
    if @remove_prefix
      @removed_prefix_string = @remove_prefix + '.'
      @removed_length = @removed_prefix_string.length
    end
    if @add_prefix
      @added_prefix_string = @add_prefix + '.'
    end
  end

  def emit(tag, es, chain)
    tag = if @tag
            @tag
          else
            if @remove_prefix and
                ( (tag.start_with?(@removed_prefix_string) and tag.length > @removed_length) or tag == @remove_prefix)
              tag = tag[@removed_length..-1]
            end 
            if @add_prefix 
              tag = if tag and tag.length > 0
                      @added_prefix_string + tag
                    else
                      @add_prefix
                    end
            end
            tag
          end
    es.each do |time,record|
      Fluent::Engine.emit(tag, time, record)
    end
    chain.next
  end
end

