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
	 
      end
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
	       of Atom then {List.append @TreatedList {NoteToExtended H} @TreatedList} % Treatedlist = NoteToExtended|treatedlistd
	       [] Name#Octave then {List.append @TreatedList {NoteToExtended H} @TreatedList}
	       [] note(name: octave: sharp: duration: instrument:) then {List.append @TreatedList H  @TreatedList}%Ici j'ai un extended note
	       [] H|T then %ici c'est un Accord
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