part of net;


/**
 * Permite construir un paquete y enviarlo de forma sencilla
 */
class BuildPacket
{
	String m_nData;
	Client m_nClient;
	
	/**
	 * Constructor
	 */
	BuildPacket( String this.m_nData, Client this.m_nClient );
	
	/**
	 * Agrega algo al paquete
	 */
	BuildPacket Add( pData )
	{
		m_nData += pData;
		return this;
	}
	
	/**
	 * Agrega un caracter
	 */
	BuildPacket AddChar( int iCode )
	{
		m_nData += new String.fromCharCode( iCode );
		return this;
	}
	
	/**
	 * Envía el resultado al cliente
	 */
	void Send()
	{	
		m_nClient.Send( m_nData );
	}
}