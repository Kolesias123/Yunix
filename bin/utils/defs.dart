part of utils;

////////////////////////////////////////////////////////////
//
// Definiciones globales
//
////////////////////////////////////////////////////////////

Duration ONE_SECOND 		= new Duration( seconds: 1 );
Duration THREE_SECONDS 		= new Duration( seconds: 3 );

AnsiPen AN_GREEN 	= new AnsiPen()..green( bg: true, bold: true );
AnsiPen AN_WHITE 	= new AnsiPen()..white();
AnsiPen AN_YELLOW 	= new AnsiPen()..yellow();
AnsiPen AN_RED 		= new AnsiPen()..red();

/**
 * Flags para comandos
 */
const int CVAR_CHEAT 	= ( 1 << 0 );
const int CVAR_SAVE 	= ( 1 << 1 );
const int CVAR_NOTIFY 	= ( 1 << 2 );

/**
 * Comandos globales
 */
ConVar developer 	= new ConVar( 'developer', '0', description: "Establece el nivel de desarrollo" );
ConVar cheats 		= new ConVar( 'sv_cheats', '0', description: 'Activa o desactiva los Cheats' );