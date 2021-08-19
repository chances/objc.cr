# Objective-C Runtime bindings
module ObjC
  extend self

  alias Selector = LibObjC::Selector
  alias Class = LibObjC::Class
  alias Ivar = LibObjC::Ivar
  alias Property = LibObjC::Property

  def sel(selector : String)
    LibObjC.selector_register(selector.chars)
  end

  def cls(name : String)
    LibObjC.get_class(name.chars)
  end

  def cls_name(cls : ObjC::Class)
    return String.new LibObjC.class_get_name(cls).as(UInt8*)
  end

  def object_cls_name(instance : ObjC::Id)
    return String.new LibObjC.object_get_class_name(instance).as(UInt8*)
  end

  def ivar_get_type(var : ObjC::Ivar)
    return String.new LibObjC.ivar_getTypeEncoding(var).as(UInt8*)
  end

  class Id
    @id : LibObjC::Id

    def initialize(id : LibObjC::Id)
      @id = id
    end

    def null?
      @id.null?
    end

    def to_unsafe
      @id
    end
  end
end

# https://developer.apple.com/documentation/objectivec/objective-c_runtime?language=objc
@[Link("objc")]
lib LibObjC
  alias Selector = Void*
  alias Id = Void*
  alias Class = Void*
  alias Ivar = Void*
  alias Property = Void*

  fun selector_register = sel_registerName(Char*) : Selector
  fun sel_get_uid = sel_getUid(Char*) : Selector
  fun msg_send = objc_msgSend(Id, Selector, ...) : Void*
  fun msg_send_super = objc_msgSendSuper(Id, Selector, ...) : Void*
  fun get_class = objc_getClass(Char*) : Class
  fun class_get_name = class_getName(Class) : Char*
  fun class_get_superclass = class_getSuperclass(Class) : Class
  fun class_get_property = class_getProperty(Class, Char*) : Property
  fun object_get_class = object_getClass(Id) : Class
  fun object_get_class_name = object_getClassName(Id) : Char*
  fun object_getInstanceVariable(Id, Char*, Void*) : Ivar
  fun ivar_getTypeEncoding(Ivar) : Char*
end
