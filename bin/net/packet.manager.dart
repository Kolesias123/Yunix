part of net;

/**
 * Procesa y administra los paquetes del cliente
 */
class PacketManager
{
	/**
	 * Cliente
	 */
	Client m_nClient;
	
	/**
	 * Lista de paquetes registrados
	 */
	HashMap<String, Packet> m_nPackets = {};
	
	/**
	 * Constructor
	 */
	PacketManager( Client this.m_nClient );
	
	/**
	 * Registra un nuevo paquete
	 */
	void Add( Packet pPacket )
	{
		m_nPackets[ pPacket.m_nPacketName ] = pPacket;
	}
	
	/**
	 * Elimina un paquete
	 */
	void Remove( String pName )
	{
		m_nPackets[ pName ] = null;
	}
	
	/**
	 * Ejecuta un paquete
	 */
	bool Run( String pName, pData )
    {
		// El paquete no existe
    	if ( !Has(pName) )
    		return false;
    	
    	Get( pName ).Run( pData );
    	return true;
    }
	
	/**
	 * Devuelve la instancia de un paquete
	 */
	Packet Get( String pName )
	{
		return m_nPackets[ pName ];
	}
    	
	/**
	 * Devuelve si el paquete esta registrado
	 */
    bool Has( String pName )
    {
    	return ( m_nPackets[pName] is Packet ) ? true : false;
    }
}