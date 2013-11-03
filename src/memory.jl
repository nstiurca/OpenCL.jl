abstract CLMemObject

#TODO: this should be implemented by all subtypes
#type MemObject <: CLMemory
#    valid :: Bool
#    ptr   :: CL_mem
#    hostbuf
#
#    function CLMemObject(mem_ptr::CL_mem; retain=true, hostbuf=nothing)
#        if retain
#            @check api.clRetainMemObject(mem_ptr)
#        end
#        m = new(true, mem_ptr, hostbuf)
#        finalizer(m, mem -> if mem.valid; release!(mem); end)
#        return m
#    end
#
#end

Base.pointer(mem::CLMemObject) = mem.ptr

Base.sizeof(mem::CL_mem) = begin
    val = Array(Csize_t, 1)
    @check api.clGetMemObjectInfo(mem, CL_MEM_SIZE, sizeof(Csize_t), Csize_t, C_NULL)
    return val[0]
end

function release!(mem::CLMemObject)
    if !mem.valid
        error("OpenCL.MemObject relase! error: trying to double unref mem object")
    end
    @check_release api.clReleaseMemObject(mem.ptr)
    mem.valid = false
end

    
#TODO: function get_info()
#TODO: function hostbuf()
#TODO: release()
#TODO: host_array()
#TODO: pointer

#TODO: enqueue_migrate_mem_objects(queue, mem_objects, flags=0, wait_for=None)
#TODO: enqueue_migrate_mem_objects_ext(queue, mem_objects, flags=0, wait_for=None)
