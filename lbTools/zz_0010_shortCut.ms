------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Funciones globales de uso com�n y accesos directos a funciones de las librer�as muy usadas.
--Nota: No son para su uso en el c�digo de las herramientas, son para uso r�pido en procesos de debug en el listener.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	global help = lb.help.getHelp --funci�n para acceder a la ayuda de las librer�as y las herramientas.
	global reloadScripts = lb.utilities.reloadScripts --funciona para recargar todos los scripts de nuevo.
)