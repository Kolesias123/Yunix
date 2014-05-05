part of net;

/**
 * Permite la creación de un paquete, para recibir o envíar.
 */
class Packet
{
	/**
	 * Nombre del paquete
	 */
	String m_nPacketName;
	
	/**
	 * Cliente
	 */
	Client m_nClient;
	
	/**
	 * Acción
	 */
	Function m_nCallback;
	
	/**
	 * Constructor
	 */
	Packet( String this.m_nPacketName, Client this.m_nClient, Function this.m_nCallback )
	{
		m_nClient.PackManager.Add( this );
	}
	
	/**
	 * Ejecuta la acción del paquete
	 */
	void Run( pData )
	{
		// No podemos hacer nada con este paquete
		if ( m_nCallback == null )
			return;
		
		m_nCallback( pData );
	}
}