class Fluent::RetagOutput < Fluent::Output
  Fluent::Plugin.register_output('retag', self)

  config_param :tag, :string, :default => nil
  config_param :remove_prefix, :string, :default => nil
  config_param :add_prefix, :string, :default => nil
  config_param :remove_suffix, :string, :default => nil
  config_param :add_suffix, :string, :default => nil

  def configure(conf)
    super
    if not @tag and not @remove_prefix and not @add_prefix and not @remove_suffix and not @add_suffix
      raise Fluent::ConfigError, "missing remove_prefix and add_prefix and remove_suffix and add_suffix"
    end
    if @tag and (@remove_prefix or @add_prefix or @remove_suffix or @add_suffix)
      raise Fluent::ConfigError, "tag and remove_prefix/add_prefix/remove_suffix/add_suffix must not be specified"
    end
    if @remove_prefix
      @removed_prefix_string = @remove_prefix + '.'
      @removed_length = @removed_prefix_string.length
    end
    if @add_prefix
      @added_prefix_string = @add_prefix + '.'
    end

    if @remove_suffix
      @removed_suffix_string = '.' + @remove_suffix
      @removed_suffix_length = @removed_suffix_string.length
      @removed_suffix_pos = 0 - @removed_suffix_length
    end
    if @add_suffix
      @added_suffix_string = '.' + @add_suffix 
    end
  end

  def emit(tag, es, chain)
    tag = if @tag
            @tag
          else
            if @remove_suffix and
                ((tag.end_with?(@removed_suffix_string) and tag.length > @removed_suffix_length) or tag == @remove_suffix)
              tag = tag[0...@removed_suffix_pos]
            end
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
            if @add_suffix 
              tag = if tag and tag.length > 0
                      tag + @added_suffix_string
                    else
                      @add_suffix
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

