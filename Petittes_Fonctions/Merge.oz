%%%MERGE

%Je vais faire 3 fonctions:
%Une qui se charge d'additionner deux listes deux à deux avec un facteur d'intensité
%Une autre qui se charge de normaliser une liste entre -1 et 1
%Enfin, une dernière qui se charge de merger le tout

%%%%%%%%%%%SumList
%INPUT: L1 I1 L2 I2 --> listes associees a une intensite. I1 et I2 sont entre 0 et 1
%OUTPUT: Leur somme ponderee
declare SumList
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
declare Normaliser
fun{Normaliser Liste}
   local FindHigh Smallest Largest Divide in
      Smallest = {NewCell 20000.0}
      Largest = {NewCell ~20000.0}

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
      
      {Divide Liste {FindHigh Liste}} %Fait Divide avec la Liste; {FindHigh Liste} permet de trouver par quel facteur il faut diviser
      
   end
   
end
%{Browse {Normaliser [10.0 9.0 ~1.0 ~21.0]}}


declare Merge
fun{Merge Liste}
   local First Run in
      First = {NewCell [0.0]}
      fun{Run L}
	 case L
	 of nil then @First
	 [] H|T then
	    
	    case H
	    of A#B then
	       First := {SumList @First 1.0 B A}
	       {Run T}
	    end
	    
	 end
      end
      {Normaliser {Run Liste}}
   end
end
%{Browse {Merge [1.0#[2.0 2.0 2.0 2.0] 2.0#[3.0 3.0 3.0 3.0 3.0 3.0]]}}


