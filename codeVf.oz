local
   % See project statement for API details.
   [Project] = {Link ['Project2018.ozf']}
   Time = {Link ['x-oz://boot/Time']}.1.getReferenceTime

   Lissage = false
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   fun{IsTrans X}
      if{Record.is X}then
	 case X
	 of duration(seconds:S B) then true %%ATTANTION On ne verifie pas si B est une partition
	 [] stretch(factor:S B) then true
	 [] drone(note:S amount:B)then true
	 [] transpose(semitones:S B)then true
	 else false
	 end
      else false
      end
   end

   fun{IsNote X}
      if{Tuple.is X}then true
      elseif {Atom.is X}then true
      else false
      end
   end
   fun{IsExtNote X}
      if{Record.is X} then
	 case X
	 of note(name:A octave:B sharp:C duration:D instrument:E) then true
	 [] silence(duration:D) then true
	 else false
	 end
      else
	 false
      end  
   end

   fun{IsChord X} %ATTENTION SI IL RECOIT UNE PARTITION IL ENVOIE TRUE
      case X
      of H|T then
	 if {IsNote H} orelse {IsTrans H} then
	    true
	 else
	    false
	 end
      else false
      end
   end

   fun{IsExtChord X} 
      case X %C'est ok selon l'enonce
      of H|T then
	 if {IsExtNote H} then
	    true
	 else
	    false
	 end
      else false
      end
   end

%---------------------ZONE DES TRANSFORMATIONS ----------------------

   fun{Transform X}
      case X
      of duration(seconds:S B) then {Duration S B}%appel a la fct duration
      [] stretch(factor:S B) then {Stretch S B}%appel a la fct stretch
      [] drone(note:S amount:B)then {Drone S B}%appel a drone
      [] transpose(semitones:S B)then {Transpose S B}%appel a transpose
      else false
      end
   end

   fun{Stretch Fact Part}   
      local StretchExt in
	 fun {StretchExt Fact EPart}
	    case EPart of nil then nil
	    [] H|T then if {IsExtNote H} then
			   case H of
			      note(name:A duration:B octave:C sharp:D instrument:E) then
			      note(name:H.name duration:Fact*H.duration octave:H.octave sharp:H.sharp instrument:H.instrument)|{StretchExt Fact T}
			   []silence(duration:A) then
			      silence(duration:Fact*A)|{StretchExt Fact T}
			   end	   
			else % H est une liste de note donc on peut lui appliquer stretch
			   {Stretch Fact H}|{Stretch Fact T}          %{List.append {Stretch Fact H} {Stretch Fact T} $ }
			end
	    end%fin case
	 end%fin fct
	 {StretchExt Fact {PartitionToTimedList Part}}
      end%fin du local
   end   

   fun {GetDuration List}
      local Accumulateur in
	 fun{Accumulateur Acc Reste}
	    case Reste
	    of nil then Acc
	    [] H|T then {Accumulateur H.duration+Acc T}
	    end      end %local
	 {Accumulateur 0.0 {PartitionToTimedList List}}
      end
   end

   fun {Duration Sec Part}
      local Fact in
	 Fact = Sec / {GetDuration Part} %doit rendre un float!
	 {Stretch Fact Part}
      end
   end
   fun{Drone Note Amount}
      local Recurs  ExtN in
	 if {IsNote Note} then ExtN = {NoteToExtended Note}
	 else ExtN =  Note end
	 
	 fun {Recurs N}
	    if N =< Amount then
	       ExtN|{Recurs N+1}
	    else %n == amount
	       nil
	    end
	 end %fct
	 {Recurs 1}
      end%local
   end

   fun{Transpose Semiton Part} %Souci si j'ai un silence dans ma part.
      local Recurs in
	 fun{Recurs Reste}
	    case Reste 
	    of H|T then
	       case H
	       of silence(duration:A) then silence(duration:A)|{Recurs T}
	       else {GetNote {GetNumber H}+Semiton}|{Recurs T}
	       end
	    []nil then nil
	    end%Case
	 end%fct
	 {Recurs {PartitionToTimedList Part}}
      end%local
   end%fct

   fun {GetNumber ExtNote}
      case ExtNote.name of 'c' then 
	 if ExtNote.sharp then 2+ 12*(ExtNote.octave-1) % do#
	 else 1 + 12*(ExtNote.octave -1 ) %do
	 end
      [] 'd' then
	 if ExtNote.sharp then 4+ 12*(ExtNote.octave-1)  %re#
	 else  3+ 12*(ExtNote.octave -1 ) %re
	 end
      [] 'e' then
	 5  +12*(ExtNote.octave -1 )%mi (mi # c'est fa)
      [] 'f' then
	 if ExtNote.sharp then 7+ 12*(ExtNote.octave-1)  % fa#
	 else 6 + 12*(ExtNote.octave -1 ) %fa
	 end
      [] 'g' then
	 if ExtNote.sharp then 9+ 12*(ExtNote.octave-1)  % sol#
	 else  8 + 12*(ExtNote.octave -1 ) %sol
	 end
      [] 'a' then
	 if ExtNote.sharp then 11+ 12*(ExtNote.octave-1)  %la#
	 else  10+ 12*(ExtNote.octave -1 ) %la
	 end
      [] 'b' then
	 12 + 12*(ExtNote.octave -1 ) %si
      end
   end

   fun {GetNote I}
      local Tab Oct N IsSharp in
	 fun{IsSharp U}
	    case U
	    of 2 then true
	    [] 4 then true
	    []7 then true
	    []9 then true
	    []11 then true
	    else false
	    end
	 end
	 N = I mod 12 %nuero de la note entre 0 et 11
      %Dièse = N mod 2 % 1 si #
	 Tab = migEtben(0:b 1:c 2:c 3:d 4:d 5:e 6:f 7:f 8:g 9:g 10:a 11:a)
	 Oct = (I div 12)+1
	 note(name:Tab.N duration:1.0 octave:Oct sharp:{IsSharp N} instrument:none)
      end
   end

%----------------------END ZONE DES TRANSFORMATIONS-------------------

   % Translate a note to the extended notation.
   fun{NoteToExtended Note}
      case Note
      of Name#Octave then
	 note(name:Name octave:Octave sharp:true duration:1.0 instrument:none)
      [] Atom then
	 case {AtomToString Atom}
	 of [115 105 108 101 110 99 101] then silence(duration:1.0)
	 [] [_] then
	    note(name:Atom octave:4 sharp:false duration:1.0 instrument:none)
	 [] [N O] then
	    note(name:{StringToAtom [N]}
		 octave:{StringToInt [O]}
		 sharp:false
		 duration:1.0
		 instrument: none)
	 end
      else     Note
	 
      end
   end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   fun {ChordToExtended Chord}
      case Chord
      of nil then nil
      [] H|T then
	 if {IsExtNote H} then
	    H|{ChordToExtended T}
	 elseif{IsTrans H} then
	    {Append {Transform H} {ChordToExtended T}}
	 else
	    {NoteToExtended H}|{ChordToExtended T}
	 end
	 
      end
   end

   fun {PartitionToTimedList Partition}
      %NB: Partition est une liste [a1 a2 a3 a4]
      %ai représente soit une note|chord|extendednote|extendedchord|transformation
      local ExtendedPart in

	 fun{ExtendedPart Part}
	    case Part
	    of nil then nil
	    []H|T then
	       if {IsExtChord H} then
		  H|{ExtendedPart T}
	       elseif {IsChord H} then
		  {ChordToExtended H}|{ExtendedPart T}
	       elseif {IsExtNote H} then
		  H|{ExtendedPart T}
	       elseif {IsNote H} then
		  {NoteToExtended H}|{ExtendedPart T}
	       else
		  {Append {Transform H} {ExtendedPart T}}
	       end    
	    end	
	 end
	 {ExtendedPart Partition}
      end
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%----------------------------------MIX------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%---------------------- ZONE DES IS-------------------

   fun {IsSamples Part}
      case Part
      of samples(Samples) then
	 {Float.is Samples.1}
      else false
      end
      
   end


   fun {IsPartition Part}
      case Part
      of partition(1:L) then

	 if {IsExtChord L.1} orelse {IsExtNote L.1}orelse  {IsNote L.1}orelse {IsChord L.1} orelse{IsTrans L.1} then
	    true
	 else
	    false
	 end
	 
      else false
      end
      
   end

   fun {IsWave Part}
      case Part of
	 wave(FileName) then true
      else false end
      
      %{String.is Part.1}
   end

   fun {IsMerge Part}
      case Part of merge(Liste) then
	 case Liste.1
	 of P#M then
	    {Float.is P}
	 else
	    false
	 end
      else
	 false  
      end
   end
   fun{IsFilter Filter}
      case Filter of nil then true
      [] repeat(amout:I M) then true
      [] loop(duration:D M) then true
      [] clip(low:S1 high:S2 M) then true
      [] echo(delay:D1 decay:D2 M) then true
      [] fade(start:D1 out:D2 M) then true
      [] cut(start:D1 finish:D2 M) then true
      [] reverse(M) then true
      else
	 false
	 
      end
      
   end

%----------------------END ZONE IS-------------------

%---------------------- ZONE DES SAMPLED-------------------


   fun {SampledWave Fname}
      {Project.readFile Fname}
   end
   

%%%MERGE

%Je vais faire 3 fonctions:
%Une qui se charge d'additionner deux listes deux à deux avec un facteur d'intensité
%Une autre qui se charge de normaliser une liste entre -1 et 1
%Enfin, une dernière qui se charge de merger le tout

%%%%%%%%%%%SumList
%INPUT: L1 I1 L2 I2 --> listes associees a une intensite. I1 et I2 sont entre 0 et 1
%OUTPUT: Leur somme ponderee
   fun{SumList L1 I1 L2 I2}
      local Recurs in
	 
	 fun{Recurs First Second}
	    case First
	    of nil then %SI LA PREMIERE LISTE TOUCHE A SA FIN
	       case Second
	       of nil then nil %LES DEUX SONT FINIES
	       []O|P then %On fait l'operation avec uniquement la deuxieme liste
		  O|{Recurs nil P}
	       end
	       
	       
	    [] H|T then %Premiere liste non finie


	       
	       case Second
	       of nil then %On fait l'operation avec uniquement la premiere liste
		  H|{Recurs T nil}	       
	       [] X|U then %dans le cas ou les deux ne sont pas finies
		  (I1*X)+(I2*H)|{Recurs T U}
	       end
	       
	    end
	    
	 end
	 {Recurs L1 L2}
      end
      
   end
%{Browse {SumList [1.0 1.0 1.0 1.0 1.0 2.0] 2.0 [2.0 2.0 2.0 2.0] 1.0}}

   %%NORMALIZE
%INPUT: Liste avec elements
%OUTPUT: tous ces elements seront graduellement mis entre -1 et 1

   fun{Normaliser Liste}
      local FindHigh Smallest Largest Divide FACTOR in
	 
	 Smallest = {NewCell 2000.0}
	 Largest = {NewCell ~2000.0}
	 fun{FindHigh L} %Cette fonction renvoie le plus grand nombre trouve dans la liste
	    case L
	    of nil then
	       if {Number.abs @Smallest} > {Number.abs @Largest} then @Smallest
	       else @Largest end
	       
	    []H|T then
	       if H > @Largest then Largest:=H {FindHigh T}
	       elseif H<@Smallest then Smallest := H {FindHigh T}
	       else
		  {FindHigh T}
	       end
	       
	    end
	    
	 end

	 fun{Divide L Facteur}
	    case L
	    of nil then nil
	    []H|T then
	       H/Facteur|{Divide T Facteur}
	    end
	    
	 end
	 thread FACTOR = {Number.abs {FindHigh Liste}} end
	 if FACTOR > 1.0 then
	    {Divide Liste FACTOR} %Fait Divide avec la Liste; {FindHigh Liste} permet de trouver par quel facteur il faut diviser
	 else
	    Liste
	 end
	 
	 
      end
      
   end


%{Browse {Merge [1.0#[2.0 2.0 2.0 2.0] 2.0#[3.0 3.0 3.0 3.0 3.0 3.0]]}}


%----------------------END ZONE DES SAMMPLED-------------------


%----------------------ZONE DES FILTRES----------------------------

%%%%%%%%%%%%%REPEAT
%%%%%%%INPUT:  N (entier) et Music [liste]
%%%%%%%OUTPUT: [Liste]|[Liste] n fois

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
   %{Browse {Clip ~1.0 1.0 [1.0 2.0 0.64 38.2 ~22.0]}}

%%%%%%%%%%%%%Echo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   Necessite MERGE
%%%%%%%INPUT:  Delay (fl) Delay (fl) MUsic(list)
%%%%%%%OUTPUT: Music(list) avec un echo

   

%%%%%%%%%%%%%LOOP
%%%%%%%INPUT:  Duree (fl) Music(list)
%%%%%%%OUTPUT: Liste de 44100*duree(secondes) echantillons de la musique. Si arrivé à la fin alors on reprend la chanson du début

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

   fun{Reverse Music}
      {List.reverse Music $}
   end

%%%%%%%%%%%%%FADE
%%%%%%%INPUT:  Music
%%%%%%%OUTPUT: Music (on incr et decr l'intensite)

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


%-------------------END ZONE DES FILTRES--------------------------
    C = {NewCell nil}

   Pi = 3.14159265359
%--- INPUT: ​part
%---OOUTPUT: samples
   fun {Mix P2T Music}
      
      local SampledPart Merge Echo SampledFilter SampledPartition in
 % ------------------------------Fonction faisant appel à P2T-----------------------------------------
    %1)
	 fun {SampledPartition Part}
	    local SampledNote SampledChord ExtPart Parcours in
	       ExtPart = {P2T Part} %%%%%%%%%%%%%%%%%%% L FAUT ABSOLUMENT METTRE P2T APRES
	       fun {SampledNote ExtNote}

		  case ExtNote of
		     silence(duration:D) then
		     local Recursive Samp in
			Samp = {Float.toInt 44100.0*ExtNote.duration}
			fun {Recursive N}
			   if N =< Samp-1 then
			      0.0|{Recursive N+1}
			   else
			      nil
			   end
			end
			{Recursive 0}
			
			
		     end
		     
		  else
		     
		     
		     local  F A H Samp Recursive in
			H = {Int.toFloat {GetNumber ExtNote} - {GetNumber {NoteToExtended a4}}} % on fixe le La comme 0 (reference)
			F = {Pow 2.0 H/12.0}*440.0
			Samp = {Float.toInt 44100.0*ExtNote.duration}

			fun {Recursive N}
			   if N =< Samp-1 then
			      0.5*{Sin 2.0*Pi*F*{Int.toFloat N}/44100.0}|{Recursive N+1}
			   else
			      nil
			   end
			end
			A = {Recursive 0}
			if Lissage then
			   thread {Fade 0.1 0.1 A} end
			else
			   
			   A
			end
		     end
		  end
	       end

	       fun {SampledChord ExtChord}
		  local Frequences Recursive Samp SumSinus F in
		     Samp = {Float.toInt 44100.0*ExtChord.1.duration}%ExtChord.duration}
		     fun {Frequences EChord}      % renvoie une liste avec les frequence de chaque note de l'accord
			case EChord of nil then nil
			[] S|T then
			   {Pow 2.0 {Int.toFloat {GetNumber S}-{GetNumber {NoteToExtended a4}}}/12.0}*440.0|{Frequences T} %{Int.toFloat {GetNumber S}-{GetNumber {NoteToExtended a4}}}/12.0}|{Frequences T}
			end
		     end

		     F = {Frequences ExtChord}
		     fun {SumSinus Freq M} % un Ai d'un accord
			case Freq of nil then 0.0
			[] S|T then
			   0.5*{Sin 2.0*Pi*S*{Int.toFloat M}/44100.0}+{SumSinus T M} %%%%%%%%%% ICI %%%%%%%%%%%%%%%
			end
		     end
		     fun {Recursive N}% creer la tableau d'echantillions	 
			if N < Samp then 
			   {SumSinus F N}/{Int.toFloat {List.length F}}|{Recursive N+1}
			else
			   nil  %%%%%%%%%%%%%%%%%  ICI  %%%%%%%%%%%%%%%%%%%%%%%
			end
		     end
		     {Recursive 0}
		  end 
	       end
	       fun {Parcours EPart}
		  case EPart of nil then nil
		  []H|T then
		     if {IsExtNote H} then {Append {SampledNote H} {Parcours T}}
		     else
			{Append {SampledChord H} {Parcours T}}
		     end
		  end
	       end

	       {Parcours ExtPart}

	    end
	 end
	 
      %2)
	 fun{Merge Liste}
	    local First Run in
	       First = {NewCell [0.0]}
	       fun{Run L}
		  case L
		  of nil then @First
		  [] H|T then 
		     case H
		     of A#B then
			First := {SumList @First 1.0 {Mix P2T B} A} %What is P2T? On ne sait pas, doit etre sous fonction de Mix pour y acceder
			{Run T}
		     end
		  end
	       end
	       {Normaliser {Run Liste}}
	    end
	 end

	 %3)
	 fun {SampledFilter Filtre}
	    case Filtre of nil then nil
	    [] repeat(amout:I M) then {Repeat I {Mix P2T M}}
	    [] loop(duration:D M) then {Loop D {Mix P2T M}}
	    [] clip(low:S1 high:S2 M) then {Clip S1 S2 {Mix P2T M}}
	    [] echo(delay:D1 decay:D2 M) then {Echo D1 D2 {Mix P2T M}}
	    [] fade(start:D1 out:D2 M) then {Fade D1 D2 {Mix P2T M}}
	    [] cut(start:D1 finish:D2 M) then {Cut D1 D2 {Mix P2T M}}
	    [] reverse(M) then {Reverse {Mix P2T M}}
	    end
	  
	 end

	 %4)
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
	       {Merge [1.0#Music Decay#SonAvecEcho]}
      %{SilenceList 1}|nil
	    end
	 end

     % ---------------------------------End fonctions faisant appel a P2T----------

	 fun{SampledPart Music}
	    case Music
	    of nil then nil
	    []H|T then
	       if {IsSamples H} then
		  {List.append H.1 {SampledPart T}}
	       elseif {IsPartition H} then
		  {List.append {SampledPartition H.1} {SampledPart T}}
	       elseif {IsWave H} then
		  {List.append {SampledWave H.1} {SampledPart T}}
	       elseif {IsMerge H} then
		  {List.append {Merge H.1} {SampledPart T}}
	       elseif {IsFilter H} then
		  {List.append {SampledFilter H} {SampledPart T}}
	       else
		 C := H
	       end    
	    end	
	 end
	 {SampledPart Music}
      end 
      
   end


   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   Music = {Project.load 'joy.dj.oz'}
   Start

   % Uncomment next line to insert your tests.
   % \insert 'tests.oz'
   % !!! Remove this before submitting.
in
   Start = {Time}

   % Uncomment next line to run your tests.
   % {Test Mix PartitionToTimedList}

   % Add variables to this list to avoid "local variable used only once"
   % warnings.
   {ForAll [NoteToExtended Music] Wait}
   
   % Calls your code, prints the result and outputs the result to `out.wav`.
   % You don't need to modify this.
   %{Browse {Project.run Mix PartitionToTimedList [wave('pig.wav')] 'out.wav'}}
   {Browse {Project.run Mix PartitionToTimedList Music 'out.wav'}}
   %{Browse {Mix PartitionToTimedList Music}}
   {Browse @C}
   %{Browse {IsPartition}}


   
   % Shows the total time to run your code.
   {Browse {IntToFloat {Time}-Start} / 1000.0}
end