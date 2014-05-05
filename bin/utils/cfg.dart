part of utils;

/**
 * 
 */
class CFG
{
	/**
	 * Ubicación del archivo de configuración
	 */
	static String m_pConfigFile = '../config.cfg';
	
	/**
	 * Carga el archivo de configuración
	 */
	static bool Load()
	{
		Msg('\n> Cargando archivo de configuración.');
		
		File configFile = new File( m_pConfigFile );
		
		// ¡El archivo no existe!
		if ( !configFile.existsSync() )
			return false;
		
		List<String> configRead = configFile.readAsLinesSync();
		
		// Pasamos cada línea por la consola
		configRead.forEach( (String line)
		{
			Console.Process( line );
		});
		
		Msg('> La configuración ha sido cargada. \n');
		
		return true;
	}
	
	/**
	 * Guarda el archivo de configuración
	 */
	static void Save()
	{
		File configFile = new File( m_pConfigFile );
        		
        // Si el archivo existe, lo eliminamos
        if ( configFile.existsSync() )
        {
        	configFile.deleteSync();
        }
        
        // Lo volvemos a crear
        configFile.createSync();
        
        // Escribimos cada ConVar en el archivo
        ConVar.m_pConvarList.forEach( (String commandName, ConVar conObject)
        {
        	// No debe guardarse
        	if ( !conObject.CanSave() )
        		return;
        	
        	DevMsg( '[CFG.Save] Guardando $commandName...', 2 );
        	
        	configFile.writeAsStringSync( '$commandName ' + conObject.GetString() + '\n', mode: APPEND );
        });
	}
}