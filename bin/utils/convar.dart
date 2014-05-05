part of utils;

/**
 * Procesa las entradas en la consola
 */
class Console
{
	static Stream m_pStream;
	
	/**
	 * Comienza a escuchar comandos desde la consola
	 */
	static Start()
	{
		m_pStream = stdin.transform( UTF8.decoder ).transform( new LineSplitter() );
		m_pStream.listen( Process );
	}
	
	/**
	 * Procesa un comando
	 */
	static Process( String pCommand )
	{
		List<String> args 	= pCommand.split(' ');
		String commandName 	= args[0];
		
		ConVar convarObject 	= ConVar.Get( commandName );
		ConAction conactObject 	= ConAction.Get( commandName );
		
		// No ha escrito nada?
		if ( commandName.isEmpty )
			return;
		
		// El comando no ha sido registrado
		if ( convarObject == null && conactObject == null )
		{
			print( 'El comando $commandName no existe.' );
			return;
		}
		
		//
		// Se trata de un ConVar
		//
		if ( convarObject != null )
		{
			// Estableciendo un valor
			if ( args.length == 2 )
			{
				convarObject.SetValue( args[1] );
			}
			
			// Solo queremos imprimir su valor
			if ( args.length == 1 )
			{
				convarObject.PrintInfo();
			}
		}
		
		//
		// Se trata de un ConAction
		//
		if ( conactObject != null )
		{
			conactObject.Run( args );
		}
	}
}

/**
 * Permite crear comandos que realizen acciones
 */
class ConAction
{
	/**
	 * Nombre del comando
	 */
	String m_pName;
	
	/**
	 * Acción al activarse
	 */
	Function m_pCallback;
	
	/**
	 * Descripción
	 * TODO: ¿Es necesario?
	 */
	String m_pDescription;
	
	/**
	 * Lista de comandos
	 */
	static HashMap<String, ConAction> m_pConActionList = {};
	
	/**
	 * Constructor
	 */
	ConAction( String pName, Function pCallback, [String pDescription = ''] )
	{
		m_pName 		= pName;
		m_pDescription 	= pDescription;
		m_pCallback 	= pCallback;
		
		// Lo agregamos a la lista
		m_pConActionList[ pName ] = this;
	}
	
	/**
	 * Ejecuta el comando
	 */
	void Run( List<String> pArgs )
	{
		m_pCallback( pArgs );
	}
	
	/**
	 * Devuelve si el comando existe
	 */
	static bool Exists( String pName )
    {
    	if ( m_pConActionList[pName] == null )
    		return false;
    	
    	return true;
    }
    
	/**
	 * Devuelve la instancia [ConAction] del comando
	 */
    static ConAction Get( String pName )
    {
    	return m_pConActionList[pName];
    }
}

/**
 * Permite crear comandos que guarden información
 */
class ConVar
{
	/**
	 * Nombre del comando
	 */
	String m_pName;
	
	/**
	 * Valor actual
	 */
	var m_pValue;
	
	/**
	 * Descripción
	 */
	String m_pDescription;
	
	/**
	 * Configuración
	 */
	int m_iFlags; // m_iButtons |= IN_MOUSE1; - m_iButtons &= ~IN_MOUSE1;
	
	/**
	 * Acción al guardar un nuevo valor
	 */
	Function m_pCallback;
	
	/**
	 * Lista de ConVar
	 */
	static HashMap<String, ConVar> m_pConvarList = {};
	
	/**
	 * Constructor
	 */
	ConVar( String pName, pDefaultValue, {String description: "", int flags: 0, Function callback: null} )	
	{
		m_pName 		= pName;
		m_pValue 		= pDefaultValue;
		m_pDescription 	= description;
		m_iFlags 		= flags;
		m_pCallback 	= callback;
		
		// Lo agregamos a la lista
		m_pConvarList[ pName ] = this;
 	}
	
	void Init() { }
	
	/**
	 * Devuelve si el comando debe ser guardado
	 */
	bool CanSave()
	{
		return ( m_iFlags & CVAR_SAVE ) == 0 ? false : true;
	}
	
	/**
	 * Devuelve si tiene una acción
	 */
	bool HasCallback()
	{
		return ( m_pCallback is Function );
	}
	
	/**
	 * Establece el valor del comando
	 */
	void SetValue( pValue )
	{
		m_pValue = pValue;
		
		// Ejecutar nuestro callback
		if ( HasCallback() )
			m_pCallback( pValue );
	}
	
	/**
	 * Devuelve el valor en [bool]
	 */
	bool GetBool()
	{
		return ( GetInt() == 0 ) ? false : true;
	}
	
	/**
	 * Devuelve el valor en [String]
	 */
	String GetString()
	{
		return m_pValue.toString();
	}
	
	/**
	 * Devuelve el valor en [int]
	 */
	int GetInt()
	{
		if ( m_pValue is int )
			return m_pValue;
		
		return int.parse( m_pValue.toString(), onError: (e) { return 0; } );
	}
	
	/**
	 * Devuelve el valor en [double]
	 */
	double GetDouble()
	{
		if ( m_pValue is double )
			return m_pValue;
					
		return double.parse( m_pValue.toString(), (e) { return 0.0; } );
	}
	
	/**
	 * Imprime información del comando
	 */
	void PrintInfo()
	{
		print('');
		print('>> $m_pName : $m_pDescription');
		print('- $m_pValue');
		print('');
	}
	
	/**
	 * Devuelve si el comando existe
	 */
	static bool Exists( String pName )
	{
		if ( m_pConvarList[pName] == null )
			return false;
		
		return true;
	}
	
	/**
	 * Devuelve la instancia [ConVar] del comando
	 */
	static ConVar Get( String pName )
	{
		return m_pConvarList[pName];
	}
}