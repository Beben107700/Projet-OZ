local
   % See project statement for API details.
   [Project] = {Link ['Project2018.ozf']}
   Time = {Link ['x-oz://boot/Time']}.1.getReferenceTime

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   % Translate a note to the extended notation.
   fun {NoteToExtended Note}
      case Note
      of Name#Octave then
         note(name:Name octave:Octave sharp:true duration:1.0 instrument:none)
      [] Atom then
         case {AtomToString Atom}
	 of [_] then
	    note(name:Atom octave:4 sharp:false duration:1.0 instrument:none)
	 [] [N O] then
	    note(name:{StringToAtom [N]}
		 octave:{StringToInt [O]}
		 sharp:false
		 duration:1.0
		 instrument: none)
	 end
      else
	 Note
	 
      end
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   fun {ChordToExtended Chord}
      %Chord est une MOTHERFUKING LISTE H|T
      %On doit renvoyer une MOTHERFUCKING LISTE qui comprend des EXTENDED NOTE
      local C in
	 C = {NewCell nil}
	 for X in Chord do
	    C := {NoteToExtended X}|@C
	 end
	 
      end
   end
   
      
	 
	 
      
   end
   
   fun {PartitionToTimedList Partition}
      %NB: Partition est une liste [a1 a2 a3 a4]
      %ai représente soit une note|chord|extendednote|extendedchord|transformation
      
      local Appel TreatedList Duree Transform in
	 TreatedList = {NewCell nil} %liste
	 avec tous les extendedsound
	 Duree = {NewCell 0} % entier représentant le nombre de secondes totales
	 Transform = {NewCell nil} %liste comportant toutes les transformation

	 proc{Appel L}
	    case L
	    of nil then  @TreatedList
	    [] H|T then
	       case H
	       of Atom then TreatedList:= {List.append @TreatedList {NoteToExtended H} $} % Treatedlist = NoteToExtended|treatedlistd
	       [] Name#Octave then TreatedList:= {List.append @TreatedList {NoteToExtended H} $}
	       [] note(name: octave: sharp: duration: instrument:) then TreatedList := {List.append @TreatedList H  $}%Ici j'ai un extended note
	       [] H|T then TreatedList := {List.append @TreatedList {ChordToExtended H} $}%ici c'est un Accord 
	       end
	       {Appel T}
	    else
	       @flat
	    end   
	 end
	 {Appel Partition}

	 end
	 
      end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

      fun {Mix P2T Music}
      % TODO
	 {Project.readFile 'wave/animaux/cow.wav'}
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
   {Browse {Project.run Mix PartitionToTimedList Music 'out.wav'}}
   
   % Shows the total time to run your code.
   {Browse {IntToFloat {Time}-Start} / 1000.0}
   end