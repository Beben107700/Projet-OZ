
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%REVERSE
%INPUT sample1|sample2|sample3|nil
%OUTPUT
declare Reverse
fun{Reverse Music}
   {List.reverse Music $}
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%REPEAT
%INPUT repeat(amount:natural music)
%OUTPUT repeter la fonction un nombre de fois
declare Repeat
fun{Repeat Natural Music}
   local For in
      fun{For N}
	 if N=<Natural then
	    {Append Music {For N+1}}
	 else
	    nil
	 end
	 {For 1}
      end
      
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%LOOP
%INPUT loop(seconds:duration music)



