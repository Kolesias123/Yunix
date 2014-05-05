part of net;

/**
 * Clase para tener en un solo lugar todas los callback
 * de los paquetes
 */
class PacketProcess
{
	/**
	 * Cliente
	 */
	Client m_nClient;
	
	/**
	 * Constructor
	 */
	PacketProcess( Client this.m_nClient );
	
	/**
	 * Registra los paquetes que se pueden recibir
	 */
	void Init()
	{
		new Packet( 'VERSIONCHECK', m_nClient, VersionCheck );
		new Packet( 'REGISTER', m_nClient, RegisterUser );
		new Packet( 'LOGIN', m_nClient, Login );
	}
	
	/**
	 * >> VERSIONCHECK
	 */
	void VersionCheck( pData )
	{
		// Versión válida
		if ( pData == 'client002' || pData == 'client003' )
		{
			Send('ENCRYPTION_OFF');
			Build('SECRET_KEY').AddChar(13).Add('1337').Send();
			
			return;
		}
		
		// Algo malo ocurrio contigo
		m_nClient.Disconnect();
	}
	
	/**
	 * >> REGISTER
	 */
	void RegisterUser( pData )
	{
		// Separamos los valores por saltos de linea
		var splitData 		= pData.split( chr(13) );
		var registerData 	= {};
		
		// Por cada valor recibido
		splitData.forEach( (String row) 
		{ 
			var splitRow = row.split('=');
			
			// Información invalida
			if ( splitRow.isEmpty || splitRow.length == 1 )
				return;
			
			// Lo agregamos a la lista
			registerData[ splitRow[0] ] = splitRow[1];
		});
		
		// Algo aquí esta mal, no se recibio ningún dato
		if ( registerData.isEmpty )
		{
			m_nClient.Disconnect();
			return;
		}
		
		HabboManager.Exists( registerData['name'] ).then( (bool result) 
		{ 
			// El nombre de usuario esta ocupado
			if ( result )
			{
				// TODO
				m_nClient.Disconnect();
				return;
			}
			
			// Esto no es necesario
			registerData.remove( 'has_read_agreement' );
		
			// Insertamos el Jugador a la base de datos
			HabboManager.AddPlayer( registerData );
		});
	}
	
	/**
	 * >> LOGIN
	 */
	void Login( pData )
	{
		// Por seguridad, ya no podemos escuchar estos paquetes
		m_nClient.PackManager.Remove( 'REGISTER' );
	}
	
	/**
     * Envía información al cliente
     */
    void Send( String pData )
    {
    	m_nClient.Send( pData );
    }
    	
    /**
     * Devuelve una nueva instancia de [BuildPacket]
     */
    BuildPacket Build( String pData )
    {
    	return new BuildPacket( pData, m_nClient );
    }
}