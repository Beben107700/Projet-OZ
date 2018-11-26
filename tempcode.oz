declare {Stretch S}
fun{Stretch Partit Facteur}
   local ExtPartit in
      ExtPartit = {PartitionToTimedList Partit}
      C = {NewCell nil}
      for S in ExtPartit do
	 if {IsExtNote S} then
	    C:= {List.append @C note(name:S.name duration:Fact*S.duration octave:S.octave sharp:S.sharp instrument:S.instrument) $}
	 elseif {IsExtChord S} then {Stretch S Facteur}
	 else
	    skip%SI TU AS UNE TRANSFORMATION CEST LE BORDEL
	 end    
      end%end du for
      @C %On rend ici la liste avec les notes multipliées
   end%end du local
end
