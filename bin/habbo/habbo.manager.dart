part of habbo;

ConVar start_credits = new ConVar( 'sv_start_credits', '0', description: 'Cantidad de créditos al registrarse' );

class HabboManager
{
	static void Init()
	{
		start_credits.Init();	
	}
	
	/**
	 * Agrega un nuevo Jugador a la base de datos
	 */
	static void AddPlayer( HashMap pData )
	{
		// Más información
		pData['credits'] = start_credits.GetInt();
		
		MySQL.Insert( 'players', pData );
	}
	
	/**
	 * Devuelve si el Jugador existe
	 */
	static Future<bool> Exists( String pUsername )
	{
		var r = new Completer<bool>();
		
		// Realizamos la consulta
		MySQL.Query( 'SELECT * FROM players WHERE name = "$pUsername" LIMIT 1' ).then( (result)
		{
			result.length.then( (i) 
			{ 
				r.complete( (i > 0) );
			});
		});
		
		return r.future;
	}
}