part of net;

ConVar net_port 	= new ConVar( "sv_net_port", 1313, flags: CVAR_SAVE );
ConVar net_address 	= new ConVar( "sv_net_address", 0, flags: CVAR_SAVE );

ConVar max_online = new ConVar( "sv_max_online", 3000, flags: CVAR_SAVE );

/**
 * Crea el servidor y procesa las conexiones entrantes
 */
class Server
{
	/**
	 * ¿El servidor esta preparado?
	 */
	static bool m_bStarted = false;
	static bool get HasStarted => m_bStarted;
	
	/**
	 * Lista de clientes conectados
	 */
	static HashMap<Socket, Client> m_nClients = {};
	
	/**
	 * Prepara la clase
	 */
	static void Init()
	{
		net_port.Init();
		net_address.Init();
	}
	
	/**
	 * Devuelve el número de Jugadores conectados
	 */
	static int get PlayersOnline
	{
		int count = 0;
		
		m_nClients.forEach( (Socket sock, Client clientObj) 
        { 
        	// No hay ningún cliente aquí
        	if ( clientObj == null )
        		return;
        	
        	if ( !clientObj.IsConnected )
        		return;
        	
        	++count;
        });
		
		return count;
	}
	
	/**
	 * Crea y comienza el servidor
	 */
	static void Start()
	{
		InternetAddress address = InternetAddress.ANY_IP_V4;
		
		// Debemos usar la IP v6
		if ( net_address.GetInt() == 1 )
			address = InternetAddress.ANY_IP_V6;
		
		Msg( '\n> Creando socket en ${address.address}:' + net_port.GetString() );
		
		// Creamos un servidor de Sockets
		ServerSocket.bind( address, net_port.GetInt() ).then( (socket) 
		{ 
			// Escuchamos todas las conexiones entrantes
			socket.listen( OnConnection );
			
			// Estamos preparados
			m_bStarted = true;
			
			Msg( '> Conexión creada, empezando a escuchar... \n' );
			
			// Verificamos las conexiones cada 1s
			new Timer.periodic( const Duration(seconds: 1), CheckConnections );
	
		})
		.catchError( (e) 
		{ 
			Msg( '> ¡Ha ocurrido un problema al crear el servidor! Es posible que el puerto se encuentre ocupado o bloqueado.' );
		});
	}
	
	/**
	 * Devuelve si el Socket puede conectarse al servidor
	 */
	static bool CanConnect( Socket pSocket )
	{
		// Limite de Jugadores superado
		if ( PlayersOnline >= max_online.GetInt() )
        {
        	pSocket.close();
        	return false;
        }
		
		return true;
	}
	
	/**
	 * [Evento] Alguien intenta conectarse al servidor
	 */
	static void OnConnection( Socket pSocket )
	{
		// Lo sentimos, pero no puedes conectarte
		if ( !CanConnect(pSocket) )
		{
			pSocket.close();
			return;
		}
		
		DevMsg( '[Server.OnConnection] Recibiendo nueva conexión de ${pSocket.remoteAddress.address}...', 2 );
		
		// Agregamos el cliente a la lista
		m_nClients[ pSocket ] = new Client( pSocket );
	}
	
	/**
	 * Verifica la salud de las conexiones
	 */
	static void CheckConnections( t )
	{
		m_nClients.forEach( (Socket sock, Client clientObj) 
		{ 
			// No hay ningún cliente aquí
			if ( clientObj == null )
				return;
			
			// El cliente se ha desconectado, lo eliminamos
			if ( !clientObj.IsConnected )
				RemoveClient( clientObj );
		});
	}
	
	/**
	 * Elimina un cliente de la lista de conectados
	 */
	static void RemoveClient( Client pClient )
	{
		pClient.OnDisconnect();
		m_nClients[ pClient.MySocket ] = null;
	}
}