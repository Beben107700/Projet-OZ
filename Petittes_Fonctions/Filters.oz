
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ZONE DES FILTRES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%TODO _ A FAIRE _ TE DOEN%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%CUT


%%%%%%%%%%%%%REPEAT
%%%%%%%INPUT:  N (entier) et Music [liste]
%%%%%%%OUTPUT: [Liste]|[Liste] n fois
declare Repeat
fun{Repeat Natural Music}
   local For in
      fun{For N}
	 if N=<Natural then
	    {Append Music {For N+1}}
	 end

      end
      	 {For 1}
   end
end


%%%%%%%%%%%%%CLIP
%%%%%%%INPUT:  Low (float) High(float) Music([lsite])
%%%%%%%OUTPUT: Music[Liste] ! borné entre low et high
declare Clip
fun{Clip Low High Music}
   local Recurs in
      
      fun{Recurs Liste}
	 case Liste
	 of H|T then
	    
	    if H>High then High|{Recurs T}
	     elseif H<Low then Low|{Recurs T}
	    else
	       H|{Recurs T}
	    end
	    
	 else nil
	 end 
      end%end function
      
      {Recurs Music}
   end
end
{Browse {Clip ~1.0 1.0 [1.0 2.0 0.64 38.2 ~22.0]}}

%%%%%%%%%%%%%Echo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   Necessite MERGE
%%%%%%%INPUT:  Delay (fl) Delay (fl) MUsic(list)
%%%%%%%OUTPUT: Music(list) avec un echo
declare Echo
fun {Echo Delay Decay Music}
   local  SilenceList SamplesToSilence SonAvecEcho in

      SamplesToSilence = {Float.toInt Delay*44100.0}
      fun {SilenceList N}%finit par a|a et pas a|a|nil
	 if N < SamplesToSilence then
	    N|{SilenceList N+1}
	 else %n == amount
	    N
	 end
      end
      SonAvecEcho = {SilenceList 1 }|Music
      %Je dois rendre un MERGE(1.0#Music Decay#SonAvecEcho)
      {Mix P2T [merge(1.0#Music Decay#SonAvecEcho)]}
      %{SilenceList 1}|nil
   end
   
end


%%%%%%%%%%%%%LOOP
%%%%%%%INPUT:  Duree (fl) Music(list)
%%%%%%%OUTPUT: Liste de 44100*duree(secondes) echantillons de la musique. Si arrivé à la fin alors on reprend la chanson du début
declare Loop
fun{Loop Duree Music}
   local Recursion NombreTotalSample in
      
      NombreTotalSample = {Float.toInt Duree*44100.0}
      fun{Recursion N Liste}


	 if N=<NombreTotalSample then 
	    
	    case Liste
	    of H|nil then
	       H|{Recursion N+1 Music}
	    [] H|T then
	       H|{Recursion N+1 T}
	    end
	    
	 else nil
	    
	 end

		 
      end
      {Recursion 1 Music}
   end
end




%%%%%%%%%%%%%REVERSE
%%%%%%%INPUT:  Music sous forme a1|a2|a3|nil a appartient ai[-1;1]
%%%%%%%OUTPUT: a3|a2|a1|nil
declare Reverse
fun{Reverse Music}
   {List.reverse Music $}
end



%%%%%%%%%%%%%FADE
%%%%%%%INPUT:  Music
%%%%%%%OUTPUT: Music (on incr et decr l'intensite)
declare Fade
fun{Fade Start Out Music}
   local StartEch OutEch Increment A1 A2 A3 in
      StartEch = {Float.toInt Start*44100.0}
      OutEch = {Float.toInt Out*44100.0}
      %INT StartEch et OutEch
      %FLOAT H
      %INT Borne
      %INT N
      fun{Increment N List Borne}
	 case List
	 of nil then nil
	 [] H|T then
	    if N=<Borne then
	       (H*{Int.toFloat N})/{Int.toFloat Borne}|{Increment N+1 T Borne}
	    else
	       H|{Increment N+1 T Borne}
	       
	    end
	 end
	 
	 
	 
      end
      A1 = {Increment 1 Music StartEch}
      A2 = {Reverse A1}
      A3 = {Increment 1 A2 OutEch}
      {Reverse A3}

   end%local
end
%{Browse {Fade 4.0 4.0 [1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0]}}
%{Browse {Fade 4.0 4.0 [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]}} %TEST QUI N'IRA PAS PSQ ON A DES INT

declare Cut
fun{Cut Start Finish Music}
   local Nstart Nstop Recursion in
      Nstart = {Float.toInt Start*44100.0}
      Nstop = {Float.toInt Finish*44100.0}
      fun{Recursion N Liste}
	 if N =< Nstop then
	    case Liste
	    of H|T then
	       if N<Nstart then
		  0.0|{Recursion N+1 T}
	       else
		  H|{Recursion N+1 T}
	       end
	       
	    end
	    
	    
	 else nil end
	 
      end
      
      {Recursion 1 Music}
   end
   
end
%{Browse {Cut 4.0 9.0 [1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0 ]}}
%{Browse 1}