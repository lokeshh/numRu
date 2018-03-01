require "numru/version"

# module Numru
#   # Your code goes here...
# end


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
    # if obj.respond_to? :class
    #   obj
    # elsif obj.__class__.__name__ == 'ndarray'
      NumRu.new obj
    # else
    #   obj
    # end
  end

  def [](*args)
    args.map! do |i|
      case i
      when Range
        last = i.end == -1 ? nil : i.end + 1
        @@blt.slice(i.begin, last)
      when NumRu
        i.np_obj
      else
        i
      end
    end
    obj = @np_obj.__send__('__getitem__', args)
    NumRu.return_or_wrap obj
  end
  
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
    args.map! { |i| i.respond_to?(:class) && i.class == NumRu ? i.np_obj : i }
    obj = @np_obj.__send__ "#{m}!", *args
    NumRu.return_or_wrap obj
  end  
  
  def self.method_missing(m, *args)
    args.map! { |i| i.respond_to?(:class) && i.class == NumRu ? i.np_obj : i }
    obj = @@np.__send__ "#{m}!", *args
    return_or_wrap obj
  end
  
  def to_s
    @np_obj.__str__
  end
  
  def inspect
    @np_obj.__repr__
  end
end