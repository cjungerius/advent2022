module Day20

using DelimitedFiles

function f(mylist,n=1)
        indices = [1:length(mylist)...]

        for round in 1:n, (i,shift) in enumerate(mylist)
                oldindex = findfirst(==(i),indices)
                newindex = shift + oldindex
                newindex = mod1(newindex,length(indices)-1)
                insert!(indices,newindex,popat!(indices,oldindex))
        end

        decrypt = mylist[indices]
        start = findfirst(iszero,decrypt)
        
        sum(decrypt[mod1.([start+1000,start+2000,start+3000],length(decrypt))])
end

function solutions(io::String=joinpath(@__DIR__,"..","data","20.txt"))
        ispath(io) || (io = IOBuffer(io))
        mylist = vec(readdlm(io,Int))
        partone = f(mylist)
        parttwo = f(mylist.*811589153, 10)

        partone, parttwo
end

end