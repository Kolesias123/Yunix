//part of utils;

/**
 * Contiene información del archivo de configuración
 */
class Configuration
{
	/**
	 * Lista de los valores de todos los archivos de configuración
	 */
	static HashMap<String, HashMap> m_pConfig = {};
	
	/**
	 * Archivos de configuración a cargar
	 */
	static List<String> m_pConfigFiles = new List();
	
	/**
	 * Devuelve el resultado de cargar los archivos de configuración
	 */
	static bool Load()
	{
		Configuration.AddConfigFile( "../config.ini" );
		
		// Por cada archivo de configuración definido
		m_pConfigFiles.forEach( ( String configName ) 
		{
			
			// Cargamos
			bool result = _LoadConfig( configName );
			
			// Hubo un problema al cargar
			if ( !result )
				return false;
			
		});
		
		return true;
	}
	
	/**
	 * Carga un solo archivo
	 */
	static bool _LoadConfig( String pConfig )
	{
		File configFile = new File( pConfig );
		
		// El archivo no existe
		if ( !configFile.existsSync() )
			return false;
		
		// Leemos como archivo .ini
		Config data = Config.readFileSync( configFile );
		
		// Obtenemos las secciones del archivo
		Iterable sections = data.sections();
		
		// ¡No tiene ninguna sección!
		if ( sections.isEmpty )
			return false;
		
		sections.forEach( (String sectionName)
		{
			HashMap sectionOptions = {};
			
			data.options( sectionName ).forEach( (String optionName)
			{
				sectionOptions[optionName] = data.get(sectionName, optionName);
			});
			
			m_pConfig[sectionName] = sectionOptions;
		});
		
		return true;
	}
	
	/**
	 * Agrega un archivo a la lista de carga
	 */
	static AddConfigFile( String pFileName )
	{
		m_pConfigFiles.add( pFileName );
	}
	
	/**
	 * Devuelve un valor de la configuración
	 */
	static String Get( String pSection, String pOption )
	{
		return m_pConfig[pSection][pOption];
	}
}