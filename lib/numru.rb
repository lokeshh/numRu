require "numru/version"
require 'rubypython'

RubyPython.start


class NumRu
  @@np = RubyPython.import 'numpy'
  @@blt = RubyPython::PyMainClass.send(:new)

  attr_accessor :np_obj

  def initialize np_obj
    @np_obj = np_obj
  end

  def self.return_or_wrap obj
    obj.rubify
  rescue
    NumRu.new obj
  end

  def [](*args)
    args.map! do |i|
      case i
      when Range
        last = i.end == -1 ? nil : i.end + 1
        @@blt.slice(i.begin, last)
      when NumRu
        i.np_obj
      when String
        a, b, c = i.split(':').map { |x| x == '' ? nil : x.to_i }
        @@blt.slice(a, b, c)
      else
        i
      end
    end
    obj = @np_obj.__send__('__getitem__', args)
    NumRu.return_or_wrap obj
  end

  def []=(*args)
    args.map! do |i|
      case i
      when Range
        last = i.end == -1 ? nil : i.end + 1
        @@blt.slice(i.begin, last)
      when NumRu
        i.np_obj
      when String
        a, b, c = i.split(':').map { |x| x == '' ? nil : x.to_i }
        @@blt.slice(a, b, c)
      else
        i
      end
    end
    obj = @np_obj.__send__('__setitem__', args[0..-2], args[-1])
    NumRu.return_or_wrap obj
  end

  def self.preprocess_arg obj
    case obj
    when NumRu
      obj.np_obj
    when Range
      @@blt.range(obj.begin, obj.end+1)
    else
      obj
    end
  end

  # def ==(arg)
  #   @np_obj.__send__('__eq__', NumRu.preprocess_arg(arg))
  # end
  #
  # def < arg
  #   @np_obj.__send__('__lt__', NumRu.preprocess_arg(arg))
  # end
  #
  # def > arg
  #   @np_obj.__send__('__gt__', NumRu.preprocess_arg(arg))
  # end

  def self.arg_to_s arg
    case arg
    when Hash
      return arg.map { |k, v| "#{k}=#{v.inspect}" }
    when NumRu
      return "ObjectSpace._id2ref(#{arg.object_id}).np_obj"
    end
    arg.to_s
  end

  def method_missing(m, *args)
    args.map! { |i| NumRu.preprocess_arg i }
    m = "#{m}!" if args.any? { |i| i.respond_to?(:class) && i.class == Hash }
    obj = @np_obj.__send__ m, *args
    NumRu.return_or_wrap obj
  end

  def self.method_missing(m, *args)
    args.map! { |i| NumRu.preprocess_arg i }
    m = "#{m}!" if args.any? { |i| i.respond_to?(:class) && i.class == Hash }
    obj = @@np.__send__ m, *args
    return_or_wrap obj
  end

  def to_s
    @np_obj.__str__
  end

  def inspect
    @np_obj.__repr__
  end
end
