------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: libreria de xref
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateLib | Contiene la libreria de xref.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_xref
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria xref",	--@var: description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------
		--GETS
		------------------------------------------------

		---------------------------------------------------------------------------------------------------------------
		-- obtiene el nombre de un fichero sin el path
		---------------------------------------------------------------------------------------------------------------
		fn getNameFromFile file =
		(
			fileName = "Source File"
			
			try
				fileName = (filterString file "\\")[(filterString file "\\").count]
			catch()
			
			fileName
		),

		---------------------------------------------------------------------------------------------------------------
		-- obtiene el path de un fichero a partir de toda la ruta completa
		---------------------------------------------------------------------------------------------------------------
		fn getPathFromFile file =
		(
			filePath = "Source File"
			
			try
				filePath = substituteString file (this.getNameFromFile file) ""
			catch()
			
			filePath
		),

		---------------------------------------------------------------------------------------------------------------
		-- obtiene todos todos los nodos de xref de mesh de todos los assets pasados por parametro
		---------------------------------------------------------------------------------------------------------------			
		fn getXrefMeshNodesFromAssets assets =
		(
			xrefMeshNodes = #()
			tempNodes = #()
			
			for ast in assets do
				tempNodes = tempNodes + (lb.asset.getAssetNodesByType ast #(lb.nc.NC_classMesh)) + (lb.asset.getAssetNodesByType ast #(lb.nc.NC_classFacial)) + (lb.asset.getAssetNodesByType ast #(lb.nc.NC_classHair))
								
			for msh in tempNodes do
				if classof msh == XRefObject then
					appendIfUnique xrefMeshNodes msh 
					
			xrefMeshNodes
		),	
			
		---------------------------------------------------------------------------------------------------------------
		-- funcion para obtener el fichero Xref Cargado a partir de un objeto pasado por parametro
		---------------------------------------------------------------------------------------------------------------	
		fn getLoadedXrefFileFromNode meshObj =
		(
			file = ""
			
			if classOf meshObj == XRefObject then
				file = meshObj.filename
				
			file
		),

		---------------------------------------------------------------------------
		--busca del record pasado por parametro, todos los records de su jerarquía de records hasta llegar al nivel último
		--necesita un record
		--devuelve un array de records
		--es una funcion recursiva
		---------------------------------------------------------------------------
		fn getXrefLastLevelRecords xrefrecord =
		(
			lastLevelRecords = #()
			
			if xrefrecord != undefined then
			(
				auxChildren = #() --records hijos del actual
				
				xrefrecord.GetChildRecords &auxChildren
				
				if auxChildren.count != 0 then
				(
					for ch in auxChildren do
						lastLevelRecords += this.getXrefLastLevelRecords ch
				)
				else
					append lastLevelRecords xrefrecord
			)
			
			lastLevelRecords
		),

		---------------------------------------------------------------------------
		--devuelve todos los records de la escena que sean root
		---------------------------------------------------------------------------
		fn getXrefSceneRootRecords =
		(
			rootRecords = #() --array para almacenar todos los records root
			xrefrecords = #() --todos los xrefrecords de la escena
			
			for i=1 to objXRefMgr.recordCount do --obtiene todos los records
				append xrefrecords (objXRefMgr.GetRecord i)
				
			for rcrd in xrefRecords do
			(
				auxRoot = #()
				rcrd.GetParentRecords &auxRoot
				if auxRoot.count == 0 then
					append rootRecords rcrd
			)
			
			rootRecords
		),
		
		---------------------------------------------------------------------------
		--busca el nombre (de objeto o de material) pasado por parametro
		--en todos los xrefRecords de forma recusiva y hasta que lo encuentra.
		--es una funcion recursiva
		--devuelve el Item si lo encuentra, si no devuelve undefined
		---------------------------------------------------------------------------
		fn getXrefSourceItemByName XRefName xrefrecords:#() =
		(
			srcItem = undefined --almacena el Item buscado
			stop = false --flag para saber si parar
			
			--si no se le han pasado xrefrecords, coge todos los de la escena que sean records raiz
			if xrefrecords.count == 0 then
				xrefrecords = this.getXrefSceneRootRecords()
			
			-- 		lastLevelRecords = #() --array para almacenar los records que no tienen hijos
			-- 		
			-- 		--recorre todos los records buscando los que están en el nivel más bajo
			-- 		for rcrd in xrefRecords where not stop do
			-- 			lastLevelRecords += this.getXrefLastLevelRecords rcrd
			
			nParts = filterString XRefName "_" --separa el nombre en partes.
			
			--recorre los records del nivel actual y busca en ellos el item que coincida en nombre con el que buscamos
			--for rcrd in lastLevelRecords where not stop do
			for rcrd in xrefrecords where not stop do	
			(
				types = #(#XRefMaterialType)
				rcrd.GetItems &types &items --obtiene los items del record actual
				
				for it in items where (not stop) and (it != undefined) do
				(
					--si coincide con el nombre, tambien ha de coincidir en prefijo con el objeto que lo lleva
					--o con el archivo origen en el que está
					if it.name == XRefName then
					( 
						if nParts.count > 1 then
						(
							srcNParts = filterString it.srcItemName  "_"
							
							if srcNParts.count > 1 then
							(
								if nParts[1] == srcNParts[1] and nParts[2] == srcNParts[2] then
								(
									srcItem = it
									stop = true
								)
							)
							else 
							(
								srcFParts = filterString it.srcFileName "_"
								
								if srcFParts.count > 1 then
								(
									if nParts[1] == srcFParts[1] and nParts[2] == srcFParts[2] then
									(
										srcItem = it
										stop = true
									)
								)--if srcFParts
							)--if else srcNParts
						)--if parts > 1
					)--if
				)--for
				
				--si no lo encuentra en ese record, busca en los records hijos del actual de forma recursiva
				if srcItem == undefined then
				(
					auxChildren = #() --records hijos del actual
					rcrd.GetChildRecords &auxChildren
					
					if auxChildren.count != 0 then
						for ch in auxChildren where srcItem == undefined do
							srcItem = this.getXrefSourceItemByName XRefName xrefrecords:#(ch)				
				)--if
			)--for
			
			srcItem
		),

		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--OTHER
		------------------------------------------------

		---------------------------------------------------------------------------
		-- funcion para añadir el contenido de un fichero por Xref
		--TYPE indica el tipo de los objetos que se van a añadir, es un array de tipos
		-- si TYPE es un array vacio se añade todo
		---------------------------------------------------------------------------
		fn addXrefNodesFromFile file types:#() dupObjNameAction:#prompt dupMtlNameAction:#prompt =
		(
			if classof file == String then
			(
				objXRefMgr.dupObjNameAction = dupObjNameAction
				objXRefMgr.dupMtlNameAction = dupMtlNameAction
				
				fileObjectNames = getMAXFileObjectNames file 
				objectNamesToMerge = #()
				
				--	solo hacemos merge de las piezas que no son de tipo morph
				for n in fileObjectNames where lb.nc.ncOK n do
				(
					addsFlag = true
					
					if types.count != 0 then
					(
						parts = filterstring n "_"
						if findItem types parts[3] == 0 then
							addsFlag = false
					)
					
					if addsFlag then
						append objectNamesToMerge n				
				)			
				
				--creamos la nueva entrada de xRefObjects	
				xRefRecord = objXRefMgr.AddXRefItemsFromFile file objNames:objectNamesToMerge xRefOptions:#mergeModifiers #mergeTransformsAll
				
				if xRefRecord != undefined then
				(
					xRefRecord.includeAll = false
					xRefRecord.autoUpdate = true
				)				
			)
		),
		
		---------------------------------------------------------------------------
		-- funcion para eliminar un conjunto de nodos de Xref de la escena
		---------------------------------------------------------------------------
		fn removeXrefNodes xrefNodes =
		(
			if xrefNodes.count != 0 then
				objXRefMgr.RemoveXRefItemsFromScene xrefNodes
		),
		
		---------------------------------------------------------------------------
		-- funcion para capturar los controladores de origen  de las mallas y sustituirlos
		-- por los referenciados.
		---------------------------------------------------------------------------
		fn mergeXrefNodesControllers xrefNodes=
		(
			--obtenemos los controladores de origen y los sustituimos por los actuales ( xref controller )
			if classof xrefNodes == Array then
				if xrefNodes.count != 0 then
					for o in xrefNodes do
						if classof o.controller == XRef_Controller then
							o.controller = o.controller.getSourceCtrl true
		),
		
		---------------------------------------------------------------------------
		-- funcion para redirigir el archivo de xref
		---------------------------------------------------------------------------			
		fn retargetXrefNodesToFile newFile xrefNodes =
		(
			-- 		if classof newFile == String then
			-- 			(objXrefMgr.getrecord 1).srcfileName = newFile
			
			if classof newFile == String then
			(
				disableSceneRedraw()
				setWaitCursor()
				
				for obj in xrefNodes do
				(
					try obj.material.srcfileName = newFile	catch()
					obj.srcfileName = newFile
				)
				
				setArrowCursor()
				enableSceneRedraw()
				completeRedraw()
			)--if		
		),	
		
		---------------------------------------------------------------------------
		-- funcion para actualuizar la mesh de referencia para cuando nos da fallos
		-- mediante el asset tracking, ya que es la unica forma de arreglar este tipo de fallos
		---------------------------------------------------------------------------			
		fn refreshXrefNodes xrefNodes =
		(
			file = ""	
				
			if classof xrefNodes == Array then
				if xrefNodes.count != 0 then
					file = this.getLoadedXrefFileFromNode xrefNodes[1]
				
			filePath = this.getPathFromFile file
			fileName = this.getNameFromFile file
			strArray = #(file)
				
			-- seleccionamos el archivo actual del mesh actual y lo establecemos a 
			-- "c:\" ya que si lo seleccionamos a un string vacio luego no podemos reseleccionarlo
			if ATSOps != undefined then
			(
				ATSOps.visible = true 
				ATSOps.visible = false
			)
			
			ATSOps.refresh()
			ATSOps.SelectFiles strArray
			ATSOps.setPathOnselection "c:\\"
				
			ATSOps.refresh()
				
			-- seleccionamos de nuevo "c:\" mas el archivo del mesh y establecemos la ruta sin la ultima parte	
			ATSOps.SelectFiles ("c:\\" + fileName)
			ATSOps.setPathOnselection filePath
				
			ATSOps.refresh()
		),

		---------------------------------------------------------------------------
		--Hace un merge de todos los xref scenes y sus anidados
		---------------------------------------------------------------------------
		fn mergeXrefSceneTree =
		(
			while xrefs.getXRefFileCount() > 0 do
			(
				merge (xrefs.getXRefFile 1)
			)
		),

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
	)--lib_xref
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_xref() --crea la libreria
)