part of net;

/**
 * Comandos
 */
ConVar mysql_host 	= new ConVar( 'sv_mysql_host', '', flags: CVAR_SAVE );
ConVar mysql_user 	= new ConVar( 'sv_mysql_user', '', flags: CVAR_SAVE );
ConVar mysql_pass 	= new ConVar( 'sv_mysql_pass', '', flags: CVAR_SAVE );
ConVar mysql_dbname = new ConVar( 'sv_mysql_dbname', '', flags: CVAR_SAVE );
ConVar mysql_port 	= new ConVar( 'sv_mysql_port', 3306, flags: CVAR_SAVE );

ConVar mysql_max_connections = new ConVar( 'sv_mysql_max_connections', 10, flags: CVAR_SAVE );

/**
 * 
 */
class MySQL
{
	static ConnectionPool m_pConnection;
	static ConnectionPool get Connection => m_pConnection;
	
	static Future<Results> Query( String pQuery ) => m_pConnection.query(pQuery);
	
	/**
	 * Inicia la clase
	 */
	static void Init()
	{
		mysql_host.Init(); mysql_user.Init(); mysql_pass.Init();
		mysql_dbname.Init(); mysql_port.Init(); mysql_max_connections.Init();
	}
	
	/**
	 * Carga la tabla "config" en los comandos
	 */
	static void LoadConfig()
	{
		Connection.query( 'SELECT * FROM config' ).then( (result)
		{
			result.forEach( (row) 
			{ 
				String cmd = '${row.con} ${row.value}';
				Console.Process( cmd );
			});
		});
	}
	
	/**
	 * Establece la conexión con el servidor MySQL
	 */
	static bool Connect()
	{
		Msg( '\n> Estableciendo conexión al servidor MySQL...' );
		
		// Creamos la conexión a MySQL
		// TODO: Detectar si la conexión ha fallado
		m_pConnection = new ConnectionPool( 
				host: mysql_host.GetString(), 
				user: mysql_user.GetString(), 
				password: mysql_pass.GetString(), 
				db: mysql_dbname.GetString(),
				port: mysql_port.GetInt(),
				max: mysql_max_connections.GetInt()
		);
	
		Msg( '> La conexión se ha establecido. \n' );
		LoadConfig();
		
		return true;
	}
	
	/**
	 * Permite insertar datos en la tabla especificada
	 */
	static void Insert( String pTable, HashMap pValues )
	{
		String pQuery = 'INSERT INTO $pTable (';
		
		int ik = 0;
		int iv = 0;
		
		pValues.keys.forEach( (String key) 
		{ 
			if ( ik  > 0 )
				pQuery += ',';
			
			pQuery += key;
			++ik;
		});
		
		pQuery += ') VALUES (';
		
		pValues.values.forEach( (String value) 
		{ 
			if ( iv > 0 )
				pQuery += ',';
			
			pQuery += "'$value'";
			++iv;
		});
		
		pQuery += ')';
		
		Connection.query( pQuery ).then( (result) 
		{ 
			DevMsg('>> Query: $pQuery');
		});
	}
}