module Day20

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

end