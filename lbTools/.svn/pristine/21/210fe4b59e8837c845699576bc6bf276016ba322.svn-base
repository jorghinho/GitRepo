------------------------------------------------------------------------------------------------------------------------------------------------
--@Desc: Librería que contienene funciones sacadas del codigo opensource de blur.
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: lib_blur | Contiene la libreria blur.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_blur
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),												--@var: string | def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),									--@var: string | defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,													--@var: name | category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: string | className | Nombre de la libreria.
		description = "Libreria plantilla",									--@var: string | description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
		/*
		*=====================================================
		* Código de BLUR para obtener todos los bitmaps de la escena
		*=====================================================
		*/
		-----------------------------------------------------------------------------------
		--@fn: array | trim_dups | Elimina los elementos en una array de enteros, donde estos no se corresponden con el indice del objeto dentro de la lista. 
		--@gets: array | a | Array que contiene una lista de indices.
		--@returns: array | a | Array simplificada.
		-----------------------------------------------------------------------------------
		fn trim_dups a = 
		(
			for i in a.count to 1 by -1 do 
			(
				idx = findItem a a[i]
				if (idx != 0) AND (idx != i) do deleteItem a i
			)
			a
		),
		-----------------------------------------------------------------------------------
		--@fn: string | lowercase | Convierte a lowerCase una string.
		--@gets: string | instring | String que queremos convertir.
		--@returns: string | outstring | La string en minúsculas.
		-----------------------------------------------------------------------------------		
		fn lowercase instring =
		(
			upper="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
			lower="abcdefghijklmnopqrstuvwxyz" 
			outstring=copy instring 
			for i = 1 to outstring.count do 
			(
				j=findString upper outstring[i]
				if (j != undefined) do outstring[i]=lower[j]
			)
			outstring
		),
		-----------------------------------------------------------------------------------
		--@fn: integer | name_compare_case_insensitive | Algoritmo de quicksort, para comparar strings.
		--@gets: string | s1 | Primera string a comparar.
		--@gets: string | s2 | Segunda string a comparar.
		--@returns: integer | undefined | Indices de control de posicionamiento de la string, en función al test. -1, 0 ó 1 , en función del registro que debe ir delante en el quicksort. -1 es s1, 1 para s2, y 0 implica que es independiente.
		-----------------------------------------------------------------------------------				
		fn name_compare_case_insensitive s1 s2 = 
		(
			if (this.lowercase s1.name) < (this.lowercase s2.name) then return -1
			else if (this.lowercase s1.name) > (this.lowercase s2.name) then return 1
			else return 0
		),
		-----------------------------------------------------------------------------------
		--@fn: undefined | get_maps_from_mat | Obtiene los mapas de textura de un material. Se almacenan en la array x pasada por argumentos.
		--@gets: material | mat | Material del que buscar los mapas.
		--@gets: array | x | Array donde se almacenarán los mapas
		-----------------------------------------------------------------------------------				
		fn get_maps_from_mat mat x = 
		(
			if mat.numsubs != 0 then
			(
				for i = 1 to mat.numsubs do
				(
					if mat[i] != undefined then
					(
						if classof mat[i] == SubAnim then
						(
							if superclassof mat[i].object == textureMap then
							(
								if mat[i].object != undefined then append x mat[i].object
							)
						)
						this.get_maps_from_mat mat[i] x
					)
				)
			)
		),
	
		-----------------------------------------------------------------------------------
		--@fn: undefined | get_sub_materials | Obtiene los submateriales de un material. Se almacenan en la array x pasada por argumentos.
		--@gets: material | mat | Material del que buscar los submateriales.
		--@gets: array | x | Array donde se almacenarán los submateriales
		-----------------------------------------------------------------------------------		
		fn get_sub_materials mat x = 
		(
			if mat.numsubs != 0 then
			(
				for i = 1 to mat.numsubs do
				(
					if mat[i] != undefined then
					(
						if iskindof mat[i] material == true then 
						(
							if classof mat[i] == SubAnim then
							(
								if superclassof mat[i].object == material then 
								(
									if finditem x (mat[i].object) == 0 then append x (mat[i].object)
								)
							)
							if superclassof mat[i] == material then 
							(
								if finditem x (mat[i]) == 0 then append x (mat[i])
							)
						)
						this.get_sub_materials mat[i] x
					)
				)
			)
		),

		-----------------------------------------------------------------------------------
		--@fn: array | get_all_materials | Obtiene el material pasado por parámetro y todos los submateriales que cuelgan de el.
		--@gets: material | mat | Material del que buscar los submateriales.
		--@returns: array | aa | Array de materiales que contiene el material y todos sus hijos.
		-----------------------------------------------------------------------------------			
		fn get_all_materials mat = 
		(
			aa = #()
			x = #()
			append aa mat
			this.get_sub_materials mat x
			for i in x do
			(
				if finditem aa i == 0 then append aa i
			)
			return aa
		),
	

		-----------------------------------------------------------------------------------
		--@fn: array | get_all_scene_materials | Obtiene todos los materiales de la escena.
		--@returns: array | a | Array de materiales que contiene todos los materiales de la escena.
		-----------------------------------------------------------------------------------			
		fn get_all_scene_materials = 
		(
			a = #()
			for i in $* do
			(
				if i.material != undefined then
				(
					for i in (this.get_all_materials i.material) do
					(
						if (finditem a i) == 0 then append a i
					)
				)
			)
			qsort a this.name_compare_case_insensitive
			return a
		),

		-----------------------------------------------------------------------------------
		--@fn: array | get_all_scene_maps | Obtiene el material pasado por parámetro y todos los submateriales que cuelgan de el.
		--@returns: array | b | Array de materiales que contiene todos los materiales de la escena.
		-----------------------------------------------------------------------------------				
		fn get_all_scene_maps = 
		(
			mats = this.get_all_scene_materials()
			b = #()
			for m in mats do
			(
				a = #()
				this.get_maps_from_mat m a
				join b a
			)
			trim_dups b
			qsort b this.name_compare_case_insensitive
			return b
		),

		-----------------------------------------------------------------------------------
		--@fn: array | get_bitmaps_from_maps | Obtiene los bitmaps del mapa pasado por parametros.
		--@gets: map | a | Mapa del que buscar los bitmaps
		--@returns: array | b | Array de bitmaps que contiene todos los bitmaps contenidos en un mapa.
		-----------------------------------------------------------------------------------			
		fn get_bitmaps_from_maps a = 
		(
			b = #()
			for i in a do
			(
				if classof i == Bitmaptexture then append b i
			)
			return b
		),
		
		/* 
		final del código de BLUR 
		=====================================================*/
		
		
		------------------------------------------------
		--GETS
		------------------------------------------------
		
		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
			
		------------------------------------------------
		--@fn: undefined | initSubLibraries | Inicializa todas las sublibrerías en el orden establecido.
		------------------------------------------------
		fn initSubLibraries =
		(
			_subLibraries = #()
			
			for sl in _subLibraries do sl.init()
		),
		
		------------------------------------------------
		--@fn: undefined | init | Inicializa la librería.
		------------------------------------------------
		fn init =
		(		
			this.initSubLibraries() --inicialza las librerías hijas
		),		
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--@event: create | Ejecución al crearse la instancia del struct.
		------------------------------------------------
		on create do
		(
			lb.addLibrary this --añade la libreria a la principal
		)
		
	)--lib_template
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_blur() --crea la libreria
)