
/*
Le script lanceur de l'application
*/

// position absolue du fichier 'main.sce'
filepath=get_absolute_file_path('main.sce');

// ensemble des scripts à exécuter dans leur ordre execution
list_files=["function" "util" "algo" "callback" "creator" "build" "gui"];

// execution des script : charge les données et les fonctions
for f=list_files do
    exec(filepath+f+".sce");
end

// détruit les interfaces graphiques précédentes
destroy( 'fig' );

// lancement de l'application
app=MyApp();
