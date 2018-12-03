 
 1) --------------PartitionToTimedList----------------

 1.1) Is
 	fun{IsTrans X}
 	fun{IsNote X}
 	fun{IsExtNote X}
 	fun{IsChord X}
 	fun{IsExtChord X}
 	fun{IsNote X}

 1.2) Transformations
 	fun{Stretch Fact Part} 
 	fun {Duration Sec Part}
 	fun{Drone Note Amount}
 	fun{Transpose Semiton Part}

 	fun {GetDuration List}
 	fun {GetNumber ExtNote}
 	fun {GetNote I}

1.3) Extended
	fun{NoteToExtended Note}
	fun {ChordToExtended Chord}
	fun {PartitionToTimedList Partition}

2) -------------------------Mix-------------------------

2.1) Is
	fun {IsSamples Part} % attention si samples est vide ?
	fun {IsPartition Part} % "
	fun {IsWave Part}
	fun {IsMerge Part}

2.2) Sampled
	fun {SampledPartition Part}
		fun {SampledNote ExtNote}
		fun {SampledChord ExtChord}
	fun {SampledWave Part}

	fun{Merge Liste}
	fun{Normaliser Liste}
	fun{SumList L1 I1 L2 I2}

2.3) Filtres
	fun{Repeat Natural Music}
	fun{Clip Low High Music}
	fun {Echo Delay Decay Music}
	fun{Loop Duree Music}
	fun{Reverse Music}
	fun{Fade Start Out Music}
	fun{Cut Start Finish Music}

	fun {SampledFilter Filtre}

2.4) MIX
	fun {PartToSample Part}
	