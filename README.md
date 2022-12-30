# Abondance des motifs de fixation des TFs selon l'ancienneté des CNEs.
Authors : **[Romain Villa](mailto:rvilla@edu.bio.ens.psl.eu) | [Robin Weissmann-Farbos](mailto:weissman@edu.bio.ens.psl.eu)**

_Sujet proposé par :_
* [François Giudicelli](mailto:francois.giudicelli@ens.fr) - IBENS DYOGEN research team
* [Hugues Roest Crolllius](mailto:hrc@bio.ens.psl.eu) - IBENS DYOGEN research team

## Contexte
Ce projet s’inscrit dans les recherches de l’équipe DYOGEN de l’IBENS qui s’intéresse aux génomes des Vertébrés avec une approche évolutive. L’équipe a ainsi pu identifier plus de 2 millions d’éléments régulateurs non-codants (CNEs) dans le génome humain par génomique comparative [2] et les dater.
Par ailleurs, grâce à l’outil PEGASUS, une prédiction des gènes potentiellement régulés leur est associé. Empiriquement on suppose que la régulation des gènes résulte de la reconnaissance d’un motif au sein du CNE par un facteur de transcription (TF). On s’attend à retrouver ces motifs dans le catalogue des CNEs
de l’équipe. Cependant, une des questions que l’on peut se poser à ce stade, c’est s’il existe une différence de motifs retrouvés dans les CNEs anciens (env. 300Ma) et récents (env. 100Ma)
## Données
### Extraction des CNEs
Les CNEs sont extraites à partir d'un fichier contenant leurs coordonnées chromosomiques (```.bed```) puis importé dans l'[explorarteur de génomes](https://genome.ucsc.edu/) de l'université de Santa-Cruz. A l'aide de l'outil *custom tracks* (```My Data > Custom Tracks```), on les télécharge au format ```fasta``` dans l'outil *table browser*.
### Traitement des données "brutes"
Par traitement des données, on entend la modification des entêtes des séquences fasta, leur numérotation et le tri par ancienneté de celles-ci. Par ailleurs, selon la taille du jeu de séquences et les besoins, il pourrait s’avérer nécessaire d’échantillonner ce jeu initial. Le script ```treatment.sh``` permet de faire ces traitements avec des scripts écrits en Python.
## Analyse
### Approche
Notre objectif est de regarder l'enrichissement des différents motifs de fixation sur les CNEs en utilisant ceux compilés sur [JASPAR](https://jaspar.genereg.net/download/data/2022/CORE/JASPAR2022_CORE_vertebrates_non-redundant_pfms_transfac.txt) pour les Vertébrés. Pour faire cette analyse, on a chosi d'utiliser l'outil ```matrix-scan-quick``` disponible sur [RSAT](http://rsat.sb-roscoff.fr/). Nous aurons besoin d'un fichier de [_background_](https://rsat.eead.csic.es/plants/data/genomes/Homo_sapiens_GRCh37/oligo-frequencies/2nt_upstream-noorf_Homo_sapiens_GRCh37-noov-1str.freq.gz) nous donnant les fréquences des dinucléotides pour les régions non codantes du génome _hg19_, les 841 matrices (profils de sites de fixation des facteurs de transcription) et nos jeux de CNEs, anciens et récents. Le programme _scanne_ chaque séquence et son complémentaire et cherche une correspondance avec les différents profils fournis, selon le seuil de p-valeur donné. En l'occurence, nous avons choisi un seuil à 10^-4 pour ne pas avoir trop de stringence sur les résultats afin d'avoir un premier aperçu. Les résultats obtenus de cette manière ne permettent pas d'appréhender la significativité de la correspondance trouvée, par rapport à une séquence obtenue par hasard. Pour le vérifier, nous générons deux jeux de séquences construits aléatoirement à partir des jeux de CNEs initiaux, de taille identique, et conservant la même fréquence de dinucléotides (pour une séquence) avec un programme en Python (```src/shuffling.py```).  Le programme de RSAT est lancé avec les mêmes paramètres sur toutes nos données.
### Statistiques
La question centrale que l'on s'est posé ici, c'est comment allons-nous comparer les résultats des données réelles de celles générées artificiellement et deux nos deux jeux de données d'âge différent ?
En d'autres termes, l'enjeu est de pouvoir conclure pour chaque motif s'il est significativement plus présent dans un jeu de donnée ou l'autre. Nous n'avons pas pu trouver une solution abordable et convaincante, nous optons alors pour la méthode du _bootstrap_ pour comparer nos résulats.
On effectue le _bootstrap_ sur nos jeux de CNEs et leur version artificielle (_shuffled_) respective pour obtenir des intervalles de confiance à 95% pour chacun des motifs. Pour un motif, ceux qui se chevauchent signifient qu'il n'y a pas de différence d'abondance significative dans les CNEs réelles et _shuffled_, il est donc éliminé. Pour chacun des motifs restants, un ratio d'abondance est calculé entre ces deux mêmes jeux de données. Enfin, un ratio final est calculé à partir des ratios précédents. Ce dernier étant un moyen abordable pour appréhender l'enrichissement d'un motif chez les CNEs anciennes ou récentes. Un graphe peut alors être généré pour voir la distribution de ces ratios. Nous avons réalisé ces étapes à partir de la sortie de ```matrix-scan-quick``` et du ```./script.R```.
## Résultats
![Histogramme et courbe de densité de la distribution des ratios](./plots/histo_curve_10.png?raw=true)

## Conclusion
