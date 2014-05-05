part of engine;

void Msg( pMessage )
{
	print( (pMessage) );
}

void Warning( pMessage )
{
	print( (pMessage) );
}

void Error( pMessage )
{
	print( (pMessage) );
}

void DevMsg( pMessage, [int iLevel=1] )
{	
	if ( developer.GetInt() < iLevel )
		return;

	print( (pMessage) );
}

/**
 * Clase principal del motor
 */
class Yunix
{
	/**
	 * Comienza el funcionamiento de Yunix
	 */
	static Start()
	{
		Msg( "Comenzando Yunix..." );
		
		// Registramos los comandos antes de cargar el Config
		RegisterCommands();
		
		// Preparamos todas las clases
		// TODO: Esto no debería ser necesario
		MySQL.Init();
		Server.Init();
		HabboManager.Init();
		
		// Tratamos de cargar la configuración
		if ( !CFG.Load() )
		{
			Msg( "[Yunix.Start] Ha ocurrido un problema al cargar el archivo de configuración." );
			return;
		}
		
		// Realizamos la conexión al servidor MySQL
		MySQL.Connect();
		
		// Empezamos el servidor
		Server.Start();
		
		// Empezamos a recibir Input
		Console.Start();
	}
	
	/**
	 * Registra los comandos principales
	 */
	static RegisterCommands()
	{
		developer.Init();
		cheats.Init();
	}
}