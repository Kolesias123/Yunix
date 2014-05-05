part of net;

ConVar client_timeout = new ConVar( "sv_client_timeout", "10", flags: CVAR_SAVE );

String chr( int iNumber )
{
	return new String.fromCharCodes([iNumber]);
}

/**
 * Almacena información de un cliente conectado al servidor, pero antes
 * de convertirse en Habbo
 */
class Client
{
	/**
	 * Socket del Cliente
	 */
	Socket m_nSocket;
	Socket get MySocket => m_nSocket;
	
	/**
	 * ¿Sigue conectado?
	 */
	bool m_bIsConnected = true;
	bool get IsConnected => m_bIsConnected;
	
	/**
	 * Administrador de paquetes
	 */
	PacketManager m_nPacketManager = null;
	PacketManager get PackManager => m_nPacketManager;
	
	/**
	 * Procesador de paquetes
	 */
	PacketProcess m_nPacketProcess = null;
	PacketProcess get PackProcess => m_nPacketProcess;
	
	/**
	 * Constructor
	 */
	Client( Socket this.m_nSocket )
	{
		// Creamos nuestros ayudantes
		m_nPacketManager = new PacketManager( this );
		m_nPacketProcess = new PacketProcess( this );
		
		// Registramos los paquetes
		PackProcess.Init();
		
		// Pensamos cada segundo
		new Timer.periodic( ONE_SECOND, Think );
		
		// Escuchamos por nuevos paquetes
		MySocket.listen( OnPacket );
		
		// Verificamos si el último paquete fue hace mucho tiempo
		// TODO: ¿Una forma más segura?
		MySocket.timeout( new Duration(seconds: client_timeout.GetInt()), onTimeout: (EventSink e) 
		{ 
			// Nos hemos desconectado
			m_bIsConnected = false;
		});
		
		DevMsg( '[Client] Conexión establecida con ${m_nSocket.remoteAddress.address}', 2 );
		Send( 'HELLO' + chr(13) );
	}
	
	/**
	 * Pensamiento: Bucle de ejecución de tareas
	 */
	void Think( t )
	{
		
	}
	
	/**
	 * Envia información al cliente como un paquete
	 */
	void Send( String pData )
	{
		String cmd 	= '#' + pData + chr(13) + '##';		
		DevMsg( '[Client.Send] >> $pData', 2 );
		
		// Enviamos
		MySocket.write( cmd );
	}
	
	/**
	 * Desconecta al cliente
	 */
	void Disconnect()
	{
		MySocket.close();
	}
	
	/**
	 * [Evento] El cliente se ha desconectado
	 */
	void OnDisconnect()
	{
		
	}
	
	/**
	 * [Evento] Hemos recibido un nuevo paquete
	 */
	void OnPacket( pData )
	{
		// El paquete es recibido por caracteres, hay que convertirlo a un String
		// y quitar los primeros 4 caracteres que no importan.
		String realData = new String.fromCharCodes( pData ).substring(4);
		
		// Separamos el resultado anterior por espacios, el primer resultado
		// es el nombre del paquete que estamos recibiendo
		List<String> packetData 	= realData.split(' ');
		String packetName 			= packetData[0];
		
		// Este paquete no esta registrado
		if ( !PackManager.Has(packetName) )
		{
			DevMsg( '[Client.OnPacket] $packetName no esta registrado!!!' );
			DevMsg(' >> $packetData \n', 2 );
			return;
		}
		
		String packetArg = realData.substring( packetName.length + 1 );
		
		// Ejecutamos el paquete
		DevMsg( '[Client.OnPacket] << ' + realData, 2 );
		PackManager.Run( packetName, packetArg );
	}
}