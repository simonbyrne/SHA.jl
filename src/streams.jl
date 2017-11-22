struct SHAStream{S,T} <: IO
    ctx::S
    io::T
end

function Base.read(s::SHAStream, ::Type{UInt8})
    b = Base.read(s.io, UInt8)
    update!(s.ctx, b)
    b
end
function Base.unsafe_read(s::SHAStream, p::Ptr{UInt8}, n::UInt)
    r = Base.unsafe_read(s.io, p, n)
    update!(s.ctx, unsafe_wrap(Array, p, n))
    r
end

function Base.write(s::SHAStream, b::UInt8)
    update!(s.ctx, b)
    Base.write(s.io, b)
end
function Base.unsafe_write(s::SHAStream, p::Ptr{UInt8}, n::UInt)
    update!(s.ctx, unsafe_wrap(Array, p, n))
    Base.unsafe_write(s.io, p, n)
end

digest!(s::SHAStream) = digest!(s.ctx)
