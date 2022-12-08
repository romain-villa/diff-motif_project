# Abondance des motifs de fixation des TFs selon l'ancienneté des CNEs.
Authors : **[Romain Villa](mailto:rvilla@edu.bio.ens.psl.eu) | [Robin Weissmann-Farbos](mailto:weissman@edu.bio.ens.psl.eu)**

_Sujet proposé par :_
* [François Giudicelli](mailto:francois.giudicelli@ens.fr) - IBENS DYOGEN research team
* [Hugues Roest Crolllius](mailto:hrc@bio.ens.psl.eu) - IBENS DYOGEN research team

## Définitions et contexte
## Données
### Extraction des CNEs
Les CNEs sont extraites à partir d'un fichier contenant leurs coordonnées chromosomiques (```.bed```) puis importé dans l'[explorarteur de génomes](https://genome.ucsc.edu/) de l'université de Santa-Cruz. A l'aide de l'outil *custom tracks* (```My Data > Custom Tracks```), on les télécharge au format ```fasta``` dans l'outil *table browser*.
### Traitement des données "brutes"
Après une standardisation des en-têtes de séquences (non-décrit ici) et une numérotation de chacune des CNEs, on utilise le script [```data/treatment.sh```](https://github.com/romain-villa/diff-motif_project/tree/main/data) pour le tri et l'échantillonage des données, à l'aide de deux programmes python ([```data/src```](https://github.com/romain-villa/diff-motif_project/tree/main/data/src))
Il permet de regrouper les CNEs partageant la même ancienneté dans un fichier ```fasta```. Il existera autant de fichiers ```fasta``` qu'il y a d'âges différents, ils sont ensuite rangés dans un sous-dossier. Le script permet aussi d'échantilloner ```n``` CNEs d'un fichier issu du triage et de répéter cette procédure plusieurs fois, si l'on désire des échantillons différents pour un même fichier. Ces échantillons sont également rangés dans un sous-dossier.
## Analyse
### RSAT
L'outil [RSAT](http://rsat.sb-roscoff.fr/) nous permet de scanner nos séquences et trouver les sites de fixation des facteurs de transcription à partir d'un fichier de matrices isssues de JASPAR avec une p-value associée.
## Résultats
## Conclusion
