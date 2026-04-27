--
-- PostgreSQL database dump
--

\restrict ShkyrcagrXb5p83WGgru1E602gxw9OGEXbNgXg9HTDrxBYbMhsfaaZM632hiHLI

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: deh
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO deh;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: deh
--

COMMENT ON SCHEMA public IS '';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: actors; Type: TABLE; Schema: public; Owner: deh
--

CREATE TABLE public.actors (
    name text NOT NULL
);


ALTER TABLE public.actors OWNER TO deh;

--
-- Name: documents; Type: TABLE; Schema: public; Owner: deh
--

CREATE TABLE public.documents (
    id character varying(15) NOT NULL,
    copyright_year integer,
    studio text,
    title text,
    producer text,
    writer text,
    reel_count integer,
    series text,
    uploaded_by character varying(20),
    uploaded_time timestamp without time zone,
    document_type text
);


ALTER TABLE public.documents OWNER TO deh;

--
-- Name: error_locations; Type: TABLE; Schema: public; Owner: deh
--

CREATE TABLE public.error_locations (
    location character varying(20) NOT NULL
);


ALTER TABLE public.error_locations OWNER TO deh;

--
-- Name: flagged_by; Type: TABLE; Schema: public; Owner: deh
--

CREATE TABLE public.flagged_by (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    document_id character varying(15) NOT NULL,
    user_name character varying(20) NOT NULL,
    error_location character varying(20) NOT NULL,
    error_description text
);


ALTER TABLE public.flagged_by OWNER TO deh;

--
-- Name: genres; Type: TABLE; Schema: public; Owner: deh
--

CREATE TABLE public.genres (
    genre character varying(50) NOT NULL
);


ALTER TABLE public.genres OWNER TO deh;

--
-- Name: has_character; Type: TABLE; Schema: public; Owner: deh
--

CREATE TABLE public.has_character (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    document_id character varying(15),
    character_name text,
    actor_name text,
    character_description text
);


ALTER TABLE public.has_character OWNER TO deh;

--
-- Name: has_genre; Type: TABLE; Schema: public; Owner: deh
--

CREATE TABLE public.has_genre (
    document_id character varying(15) NOT NULL,
    genre character varying(50) NOT NULL
);


ALTER TABLE public.has_genre OWNER TO deh;

--
-- Name: has_location; Type: TABLE; Schema: public; Owner: deh
--

CREATE TABLE public.has_location (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    document_id character varying(15),
    location text,
    description text
);


ALTER TABLE public.has_location OWNER TO deh;

--
-- Name: search_history; Type: TABLE; Schema: public; Owner: deh
--

CREATE TABLE public.search_history (
    id bigint NOT NULL,
    user_name character varying(20) NOT NULL,
    "time" timestamp without time zone DEFAULT now() NOT NULL,
    start_year integer,
    end_year integer,
    studio text,
    actors text,
    genres text,
    tags text,
    search_text text,
    min_reels integer,
    max_reels integer
);


ALTER TABLE public.search_history OWNER TO deh;

--
-- Name: search_history_id_seq; Type: SEQUENCE; Schema: public; Owner: deh
--

CREATE SEQUENCE public.search_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.search_history_id_seq OWNER TO deh;

--
-- Name: search_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: deh
--

ALTER SEQUENCE public.search_history_id_seq OWNED BY public.search_history.id;


--
-- Name: transcripts; Type: TABLE; Schema: public; Owner: deh
--

CREATE TABLE public.transcripts (
    document_id character varying(15) NOT NULL,
    page_number integer NOT NULL,
    content text,
    text_index_col tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, content)) STORED
);


ALTER TABLE public.transcripts OWNER TO deh;

--
-- Name: text_content_view; Type: VIEW; Schema: public; Owner: deh
--

CREATE VIEW public.text_content_view AS
 SELECT document_id,
    string_agg(content, ' '::text) AS content
   FROM public.transcripts
  GROUP BY document_id;


ALTER VIEW public.text_content_view OWNER TO deh;

--
-- Name: users; Type: TABLE; Schema: public; Owner: deh
--

CREATE TABLE public.users (
    name character varying(20) NOT NULL,
    email character varying(320) NOT NULL,
    encoded_password character varying(255)
);


ALTER TABLE public.users OWNER TO deh;

--
-- Name: view_history; Type: TABLE; Schema: public; Owner: deh
--

CREATE TABLE public.view_history (
    id bigint NOT NULL,
    document_id character varying(15) NOT NULL,
    user_name character varying(20) NOT NULL,
    viewed_at timestamp without time zone DEFAULT now() NOT NULL,
    search_id bigint
);


ALTER TABLE public.view_history OWNER TO deh;

--
-- Name: view_history_id_seq; Type: SEQUENCE; Schema: public; Owner: deh
--

CREATE SEQUENCE public.view_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.view_history_id_seq OWNER TO deh;

--
-- Name: view_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: deh
--

ALTER SEQUENCE public.view_history_id_seq OWNED BY public.view_history.id;


--
-- Name: search_history id; Type: DEFAULT; Schema: public; Owner: deh
--

ALTER TABLE ONLY public.search_history ALTER COLUMN id SET DEFAULT nextval('public.search_history_id_seq'::regclass);


--
-- Name: view_history id; Type: DEFAULT; Schema: public; Owner: deh
--

ALTER TABLE ONLY public.view_history ALTER COLUMN id SET DEFAULT nextval('public.view_history_id_seq'::regclass);


--
-- Data for Name: actors; Type: TABLE DATA; Schema: public; Owner: deh
--

COPY public.actors (name) FROM stdin;
Gladys Huletta
Charles Ogle
Mrs. William Bechtel
Richard Neill
Eddie Lyons
Lee Moran
Jean Taylor
Victoria Forde
Elmo Lincoln
Louise Lorraine
William Chapman
Ray Watson
Frank Ellis
Gordon McGregor
V. L. Barnes
James Pierce
Fred Peters
Edna Murphy
Harold Goodwin
Liu Yu-Ching
Dorothy Dunbar
D'Arcy Corrigan
Boris Karloff
Robert Bolder
Himself
Ernie Shields
Harry Depp
Countess Du Cello
Yvette Mitchell
David Hoffman
Anne Lehr
Frank Rodgers
Bob Adair
John Barrymore
Martha Mansfield
Brandon Hurst
Charles Lane
J. Malcolm Dunn
Cecil Clovelly
Nita Naldi
George Stevens
FRANCIS X. BUSHMAN
BEVERLY BAYNE
Helen Dunbar
Henri Bergman
Belle Bruce
Edmund Elton
Mrs. La Roche
William Davidson
Charles Fang
Harry D. Blakemore
Jobyna Ralston
Gertrude Astor
Johnny Walker
Lloyd Whitlock
W. V. Mong
Cleo Madison
Mark Marmus
Edna Marion
Ruth Stonehouse
Lydia Yeamans Titus
Roy Stewart
Claire Adams
Robert McKim
Joseph J. Dowling
Violet Schram
Marc Robbins
Frank Brownlee
Marie Messenger
Frederick Starr
Arthur Morrison
Wallace Beery
Belle Bennett
Lloyd Hamilton
James Kelly
Otto Fries
HERBERT RAWLINSON
HOBART BOSWORTH
AL. W. FILSON
KATHLYN WILLIAMS
BY HIMSELF
Mildred Davis
Carl Miller
J. WARREN KERRIGAN
Lois Wilson
Maud George
Harry Carey Carter
Bertram Grassby
Mr. Holland
Earl Rogers
Hoot Gibson
Dorothy Wood
Kansas Moehring
Jim Corey
Harry Jackson
Frank Keenan
Edward Burns
Lloyd Hughes
Marguerite de la Motte
James Neil
Walter Lynch
James Mason
Mattie Peters
George Read
Dick Sutherland
Stanley Blystone
Eddie Boland
Helen McNair
Arthur Trimble
Cliff Bowes
Virginia Vance
Eddie Polo
Harry Madison
Corinne Porter
Grace Cunard
Francis Ford
Angus McDonald
Jeffry Kirke
Mark Kirke
Nora Davison
Old Man Davison
BESSIE LOVE
Flora Finch
Donald Hall
Chester Barnett
Florence Short
Phil Dunham
Charles Ray
Wellington Playter
Rex De Roselli
Betty Schade
Marie Walcamp
Kingsley Benedict
Vin Moore
May Emery
Larry Kent
Grant Withers
Kit Guard
Albert Cooke
William Tucker
Stanton Heck
Ben Wils m
Joseph Girard
Helen Leslie
Charley Perley
F. MacQuarrie
Mina Cunard
Edward Cecil
Neva Gerber
William Welsh
Sessue Hayakawa
Elaine Hammerstein
Lou Tellegen
Phyllis Haver
John Patrick
Lillian Langdon
William Scott
HARRY CAREY
MOLLY MCCONNELL
NEVA GERBER
ARTHUR SHIRLEY
J. FARRELL MCDONALD
Artisto Sidney Smith
Olga Celeste
Charles Le Moyne
Billie Rhodes
Bryant Washburn
Hazel Daly
James C. Carroll
Marion Skinner
U.K. Houpt
Frank Redman
E. N. Wallack
Lee Hill
G. A. Williams
H. Barrington
Jack Curtis
Wanda Hawley
Willis Marks
Bert Woodruff
John P. Lockney
Otto Hoffman
Jeff Prouty
Elton Stone
Ardis Andrews
King
Jim Lawton
Jane Gail
Allen Holubar
William J. Welsh
Curtis Benton
Ethel Clayton
Clarence H. Geldart
Clyde Fillmore
Josephine Crowell
Jack Holt
Helen Gardner
Earle Williams
Vola Vale
Ernest Shields
Allen Forest
Henry A. Barrows
Goro Kino
Frank Seki
Gale Henry
Milton Sims
Lillian Peacock
Charles Haeffli
ART ACORD
Mary Pickford
Allan Forrest
Anders Randolph
Marc McDermott
Clare Eames
Estelle Taylor
Mme. Carrie Daumery
Eric Mayne
Lottie Pickford Forrest
Malcolm Waite
Wilfred Lucas
Courtenay Foote
Portia Justin
Louise Hutchinson
Freddie Waldo
Malcolm Blevins
Dennis Reed
Carter De Haven
Madge Kirby
Ed Clark
Leon Bary
Alan Wayne
Alix Lansing
Irene Rich
Genevieve Blinn
Ramsey Wallace
Emma Knight
Carl Stockdale
Sidney Franklin
MADGE KENNEDY
George Forth
Wray Page
Kempton Greene
Walter Hiers
Marguerite Marsh
Ben Turpin
ERMETE NOVELLI
Jetta Goudal
Godfrey Tearle
Jose Ruben
Marc Fenton
Jean Hathaway
Pete Gerald
Irving Lippner
Marguerite Leslie
Geo. Anderson
Bernard Randall
INA CLAIRE
Harry Benham
Ralph Graves
Louiszita Valentine
Myra Brooks
Anne Cornwall
Jack Duffy
Billy Engle
Bill Irving
Jimmie Harrison
WALTER FORD
MAY FIELDING
DAVID ARMSTRONG
HARVEY ARNOLD
JACK ESTABROOK
Pete Morrison
T. D. Crittenden
Eileen Sedgwick
Fred Church
Albert MacQuarrie
Mabel Ballin
Forrest Stanley
Russell Simpson
Andre De Beranger
Edna Mae Cooper
James Gordon
Edith Roberts
Alfred Hollingsworth
Burton Strikker
Calalou
Butler
Pierre
Monseieur Le Morn e
Madame Le Morn e
Maame Martin
Mother Superior
Madame La Roche
Jack Connolly
Gus Alexander
Harry Rattenberry
Edwin Arden
Barbara Tennant
Al Smith
Ella Hall
Robert Leonard
Abe Mondon
Harry Carter
Betty Mason
Jack Calvert
Reginald
Martha
Mason
Vera Sisson
Charles H. Mailes
Charles Perley
Jack Drumeir
Ivan Christy
William Franey
Gustav Froelich
Brigitte Helm
Alfred Abel
Rudolf Klein-Rogge
Theodor Loos
Heinrich George
Richard Clarke
Eugenie Woodward
Victor Kennard
David Davies
Gus Pixley
Zadee Burbank
Frank Mayo
Pinna Nesbit
Jack Drumier
Jack Roberts
Sadie Schaeffer
Violet Aksel
LEE MORAN
NEELY EDWARDS
Olive Golden
Neal Hart
Peggy Coudray
John Cossar
Nell Craig
Edmund F. Cobb
Thomas Commerford
Patrick Calhoun
Douglas Munro
Gerald Ames
Bert Wynne
Laura Cowie
Mildred Le Gue
William Jerome
Ed Coxen
Winifred Greenwood
George Field
Wm. Bertram
Charlotte Burton
Reeves Eason
Edith Borella
EDDIE POLO
INEZ McDONNELL
J. P. McGOWAN
JAY MARCHANT
JEAN PERKINS
MAGDA LANE
Mildred Moore
George Fawcett
Bessie Eyton
Frank Campeau
Tom Mix
Wm. Rhino
Charles Gerrard
Goldie Colwell
Fred Gamble
Dorothy De Vore
Harry Nolan
ANDRÉE BRABANT
SIGNORET
NORMA TALMADGE
Harrison Ford
Montagu Love
Cooper Cliffe
Ida Waterman
Michael M. Barnes
E. Fernandez
Fraser Coulter
Clara Bow
Alice Joyce
Herbert Brenon
Conway Tearle
Donald Keith
Claire Windsor
Edward Martindel
John Sainpolis
Otis Harlan
Joseph Morrison
Ruth King
Wm. Quirk
Jas. Quinn
Loyal Underwood
Bert Lindley
Wm. Orlamond
Milton Ross
J.P. Lockney
CHARLES RAY
Florence Oberle
Harry Myers
Tom McGuire
Jean Calhoun
Robert Grey
William Courtright
Ida Schumaker
MARIE WALCAMP
CHARLEY BOWERS
Ccrine Powers
Con Mac Sunday
J.C. poole
Baron Sturetz
Wm. Cameron
Eddie Dunn, Pete Raymond, Margie Evans, Frank Montgomery, Charles Hartley, Mrs. Allen Walker, Miss Wakara, Mrs. Sarah Clark, Vincent Anderson, May Dean, Henrietta Kay, Cathryn Wood, Blanche Craig, D.W. McReynolds
Constance Crawford
Hugh Chilvers
Wilson Ardmore
Amos Crawford
James B. Lowe
Virginia Grey
George Siegmann
Margarita Fischer
Eulalie Jensen
Arthur Edmund Carew
Adolph Milar
Jack Mower
Vivian Oakland
J. Gordon Russell
Skipper Zeliff
Lassie Lou Ahern
Mona Ray
Aileen Manning
John Roche
Lucien Littlefield
Gertrude Howard
Geoffery Grace
Rolfe Sedan
Marie Foster
Martha Franklin
Nelson McDowell
Grace Carlisle
CHARLIE MURRAY
CHESTER CONKLIN
Aggie Herring
DeWitt Jennings
Cissy Fitzgerald
Dorothy Dwan
Freeman Wood
Dot Farley
Leo White
Harvey Clark
Warda Howard
John Lorenze
Sydney Ainsworth
Eille Norwood
Hubert Willis
Mme d'Estarre
Robert Vallis
Paulette Del Bays
Mae Murray
Lule Warrenton
Wheeler Oakman
Clarissa Selwynne
Gretchen Lederer
Harry von Meter
Paul Nicholson
Jean Hersholt
Charles Haefli
Harry Pollard
Margari ta Fischer
Joseph Harris
Mary Neyers
Spencer Meyrick
Mary Meyrick
Frank Elliott
Martin Wall
George Harrowby
Jack Paddock
Hunt
O'Malley
Jarvis
Stacy
Fred Huntley
Trimmer
Gabriella
Thacker
Gonzeala
Dan Mason
Wilna Hervey
Eddie Harris
Edward O'Brien
Seldy Roach
George Preston
Helen Howell
James J. Corbett
Kathleen O'Connor
Frank Jonasson
Georgie Woodthorpe
William Sauter
Noble Johnson
Orrall Humphrey
Joseph Singleton
Bartley McCullum
Binsley Shaw
Rosemary Theby
Harry C. Myers
Earl White
Harry Carey
Claire du Brey
Fred Kelsey
Jack Leonard
WILLIE B. CLEVER
BUD MORRIS
JESSIE BEARDON
Florence Dye
Constanze Binney
Fatty Alexander
Fat Carr
Kewpie Ross
Lois Boyd
Gibson Gowland
Bert Lytell
Virginia Caldwell
Antrim Short
Carmen Phillips
Henry Harmon
Frank Currier
Larry Steers
Leatrice Joy
Billie Ritchie
Henry Bergman
Peggy Pearce
Beth Manners
Rodney Norton
John Steppling
Eleanor Barry
Bernard Siegel
George S. Trimble
Clara Lambert
Hassan
Mary Rowland
Joseph Kaufman
Jack Delson
William H. Turner
James Daly
Steve Carlson
Marion Putman
Allen Walker
Ruth Carlson
Beth Carlson
Thornton Hawks
JUANITA HANSEN
GEORGE CHESEBRO
FRANK CLARK
HECTOR DION
Constance Talmadge
Corliss Giles
Majorie Milton
Radeliffe Fellows
William Boshell
Ned Sparks
Beverly Bayne
Francis X. Bushman
Louise Crolius
Esther Ralston
Ernest Torrence
Louise Dresser
Richard Boyd
Pauline Blake
J. Young
Max Asher
Milburn Morante
Moyna Macgill
Betty Balfour
George Keene
Mabel Poulton
Arthur Cleave
Leal Douglas
Alec Thompson
Polly Emery
Reginal Denham
Baby Moryson
Corinne Griffith
Percy Marmont
Malcolm McGregor
Warner Oland
Clarissa Selwyn
Leota Lorraine
Claire du Bray
Martha Mattox
Pauline Starke
Gipsy O'Brien
Joseph King
Mathew Bets
Edward Langford
Evelyn C. Carrington
Charles McDonald
Lawrence Johnson
Harold Lockwood
May Allison
Hal Clements
William Khe
Josephine Ditt
Florence Vidor
Clive Brook
Greta Nissen
Philip Strange
Andre Beranger
Robert Connors
Carlton King
Geo. Field
Ida Lewis
Ferry Banks
Harry De Vere
Marion Davies
Maclyn Arbuckle
Gypsy O'Brien
Pedro de Cordoba
Jack Lloyd
George Davis
Glen Cavender
ANNA Q. NILSSON
EARL FOXE
FREDERIK LUCAS
JIMMIE ADAMS
Charlotte Merriam
Eddie Lambert
Edith Johnston
William DUNCAN
Carmel Myers
STEPHEN
WM. SCOTT
ELSIE GREESON
JOHN LANCASTER
MR. WITT
Hank Mann
Kitty Howe
May Emory
Darwin Karr
Jane Thomas
Elizabeth Risdon
Frank Stammers
Fredk. Groves
Dorothea Tree
Guy Newall
Eileen Percy
Theodore Kosloff
Ricardo Cortez
Robert Cain
Irene Dalton
Alec B. Francis
Snitz Edwards
Lillian Drew
Victor Moore
Fuller Prunes
Ethel Shannon
William Norris
Wallace MacDonald
Josef Swickard
Betty Francisco
PAUL BERGOT
MARY BROWN
GERTRUDE ASTOR
WILLIAM V. MONG
ROY McDEVITT
ARTHUR THALASSO
Robert Gerome Vincent
Bill Kilgore
Gloria Grey
Raymond Turner
Harry McCabe
Magda Lane
Fred Montague
Bert Appling
Slim Allen
Asta Nielsen
Peter Gerald
Neal Harding
Dan Russell
Lucille Hutton
Katherine Griffith
William Irving
Bert Roach
Mabel Trunnelle
Mabel Dwight
Herbert Prior
Edward Earle
Yale Benner
T. Tamamoto
Bessie Learn
Pauline Bush
Lon Chaney
Joseph De Grasse
Thurston Hall
Walter Law
Francis Joyner
Billy Bevan
John Bowers
Rudolph Schildkraut
Marguerite De La Motte
Alan Brooks
Ernie Adams
Bruce Gordon
Claude Gillingwater
Mathilda Brundage
JACKIE COOGAN
ARTHUR LAKE
RIN-TIN-TIN
Virginia Browne Faire
Jason Robards
Tom Santschi
Dave Morris
Theodore Lorch
Wilfred North
BESSIE EYTON
JOE HAZELTON
BARNEY FUREY
CHARLES WHEELock
Bob Custer
Marion Moore
Donald Moore
Monte Mallory
Nick Alby
Josephine Hill
Frank MacQuarrie
Charles Brindley
CLARA KIMBALL YOUNG
Elliott Dexter
Lionel Belmore
Wedgewood Nowell
Rosita Marstini
Orra Deveraux
Arthur Rankin
Mary Jane Saunderson
George Kuwa
Anna Q Nilsson
Frank Newburg
Myrtle Gonzalez
Robyn Adair
Leo Pierson
Eugenie Forde
Virginia Kirtley
Pansy Porter
STELLA RAZETO
GUY OLIVER
EUGENIE BESSERER
G.M.Anderson
Rodney Hildebrand
Lee Willard
Ruth Saville
Joe Phillips
Vivian Rich
Jack Richardson
Louise Lester
Ruth Roland
George Chesebro
Easter Waiters
Bob Preston
Bob Kortman
Jeff Osborne
Robert Gray
COLLEEN MOORE
Jack Mulhall
Sam Hardy
Gwen Lee
Alma Bennett
Hedda Hopper
Kate Price
Jed Prouty
Emily Fitzroy
Caroline Snowden
Yola D'Avril
Brooks Benedict
WINNIE DAVIS
ELMER DAVIS
HOWARD WESTON
MAGGIE
OFFICER HENNESSEY
COL. GODFREY HIBBARD
ARCHIE GUNN
HERCULES STRONG
"CORKSCREW" MCGANN
John H. Elliott
Walter Long
Darrell Foss
G. Burnell Manly
Teddy Whack
John Rand
Mary Malone
Baron Velska
Patrick Malone
Gloria Swanson
Lew Cody
Sylvia Ashton
Theodore Roberts
Julia Faye
Leo D. Maloney
Roy Watson
Charles Puffy
ANNA DODGE
TOM MIX
LOUELLA MAXAM
Ana Silva
Jack Pickford
Hobart Bosworth
Ian Keith
Mary Akin
Charles A. Murray
Constance Bennett
King Baggot
John Baggot
Frank Swartz
Ethel Barrymore
Beatrice Maude
Mahlou Hamilton
H. Cooper Cliffe
Percy G. Standing
Paul Lawrence
M. W. Rale
Monty Banks
Roslyn Ayre
Rodney Travers
Bob Ainslee
Neva Stokes
Dan Mallory
Jim Morton
Bill Avery
Stella Preston
WARREN KERRIGAN
Harry Beaumont
Alton Goodrich
Ernest Maupain
Geraldine Farrar
Pedro De Cordoba
Elsie Jane Wilson
Raymond Hatton
Lillian Rich
Robert Frazer
Harry S. Northrup
William Bertram
The Stranger
Jack Perrin
Henry Barrows
Leonard Clapham
Mack Wright
Ed Cozen
Jerold T. Hevener
Lellie Farrin
Babe Hardy
Bill Bowers
Alberta Vaughn
Gertrude Short
Mario Carrillo
Priscilla Dean
Vola Smith
AL ST. JOHN
Robert Graves
Spencer Bell
Harry Dunkinson
Edward Arnold
Frances Raymond
Josephine Borio
Sam Nelson
Robert Walker
Sally Crute
Fred Jones
Howard Curtis
George Melville
Ricca Allen
Jerome N. Wilson
Ed. Mack
MABEL TALIAFERRO
Ben Wilson
Dorothy Phillips
Ed Cody
Cora Clayton
North
Sweeny
Lee McGuire
William Mong
Ray Hanford
Margaret Whistler
Georgia French
Helen Bailey
Edward Hern
Ola Humphrey
ZaSu Pitts
Chester Conklin
Dale Fuller
Joan Standing
Austin Jewell
Oscar Gottell, Otto Gottell
Frank Hayes
Fanny Midgley
Hughie Mack
Tempe Pigott
James Fulton
Jack McDonald
Lon Poff
Max Tyron
Erich Von Ritzau
Nakhla
William Mollenhauer
Hugh J. McCauley
S. S. Simon
William Barlow
Mrs. E. Jones
Mrs. Reta Rebla
J. Libbey
James Gibson
Joseph W. Girard
Ashton Dearholt
JACK MULHALL
MONTE BLUE
BETTY BRONSON
William Russell
Georgie Stone
Paul Panzer
LILLIAN WADE
JACK McDONALD
SCOTT DUNLAP
Lillian Byron
Charles Dorety
Monte Banks
Robert Edeson
Stanhope Wheatcroft
Syd Crossley
Ruth Holly
Donald Morelli
Julian Eltinge
Alma Francis
Lydia Knott
Rodolph Valentino
Ed. Martindel
Kathlyn Williams
Agnes Ayres
May McAvoy
Adolphe Menjou
Robert Agnew
Dorothy Gordon
Bertram Johns
Wallace Reid
Anthony Mulvain
Ralph Lincourt
Christine Bleeker
Barbara
William Hollins
Michael Le Prim
Jack Gilbert
Edward Barron
Ineille Hutton
Inle Warrenton
Marjia Manon
Arnold Gregg
George O'Hara
Clara Horton
M.C.Ryan
Wm. Courtwright
Ena Gregory
Andrew Arbuckle
Joe Murphy
Johnny Harron
Alan Hale
Gertrude Olmstead
Betty Ross Clark
George Cooper
Rodney LaRock
Bobbie Bolder
Magna Anderson
Dave Goodwynd
Gladys Comoverhere
Charles Cook
Charles Dorian
Rube Miller
William Desmond
Francine Larrimore
William Wadsworth
Walter Baner
Helen Strickland
Mellie Grant
Herbert = Patti
Charles Sutten
Leo Gordon
Richard Tucker
WALLACE BEERY
JOHN GILBERT
VIOLA DANA
HAROLD LLOYD
Al. Faussett
Edna Marian
Hilliard Barr
BUDDY MESSINGER
Herbert Rawlinson
Brownie Vernon
Helen Wright
Ruby Cox
Jack Conolly
William Canfield
Jackie Saunders
BERT LYTTELL
Anna Q. Nilsson
Charles Arling
Millie Mc Connell
Eugene Pallette
Edward Alexander
Rita Willis
Edward Darle
John Sturgeon
Spencer Bennett
Blanche Sweet
Leonard Sheldon
J. Parks Jones
William Dale
Arthur Ashley
Dorothy Green
Lucille La Verne
J. W. Johnston
Lola Frink
Mrs. Priestly Morrison
SIR HERBERT TREE
PHILIP MERIVALE
CHARLES ROCK
E. ION SWINLEY
CICELY RICHARDS
DOUGLAS MUNRO
STELLA ST. AUDRIE
HENRY MERRELL
VIVA BIRKETT
Palmer Bowman
Maxwell Sargent
John Lancaster
Lyllian Leighton
LaFayette McKee
Jessie Beaton
Lorimer Johnson
Ted Sloman
John Bruno
Edna Fluarath
Grace Wood
Bob Newman
Art Acord
Baldwin
Beatrice Dominguez
Tote Du Crow
Paul Worden
Alice Knowland
Lilie Leslie
George King
Stella Adams
Betty Compson
Ethel Lynn
Bobby Dunn
Charlotte Mineau
Paul Kendrid
Mary Fulton
Frank Overton
James Overton
Vesta Pegg
William Gettinger
WILLIAM E. LAWRENCE
Matt Moore
BEBE DANIELS
Iris Stuart
James Hall
Ford Sterling
Mabel Julienne Scott
Tom Ricketts
George Grandee
Andre Lanoy
J.WARREN KERRIGAN
MAUD GOERGE
HARRY CARTER
HARRY GRIFFITH
LOIS WILSON
RAYMOND HANFORD
William Haines
Walter James
Gordon Griffith
Carlo Schipa
Spec O’Donnell
Hugh Fay
Joe Butterworth
Eugene Jackson
Fatty Voss
Gladys Roach
Richard Smith
MAY McAVQY
Walter McGrail
Pat Moore
Charles Bennett
Mary Jane Irving
Carrie Clark Ward
Arthur Hoyt
Mack Swain
Harry Gribbon
Harry McCoy
LEO D. MALONEY
GOLDIE COLWELL
SID JORDAN
Patsy Ruth Miller
Chas. Gerard
Glenn Tryon
Geo. Fawcett
Sidney Bracey
Max Ascher
Hal Clarenden
Frank W. Smith
Mrs. Brundage
Marshall Neilan
Mary Charleson
Camile D’Arcy
Margaret Fawcett
Cecil Holland
Charles Gerard
Fannie Cohn
Frank McGlynn
Nellie Grant
Guido Colucci
Charles Sutton
Charles McGee
James Harris
Robert Kegerr
Richard Peer
Tom Sparks
Adele Farrington
Edna Payne
Edith Kessler
Mlle. Josette Andriot
Mr. Brevannes
Mr. Teddy
Miss Gladys
Mr. Feyder
Rita Jordon
R. E. Bradbury
Gordon Dawson
Amy Norris
Tom Moore
Lucy Fox
Henry Hallam
Phil Ryley
Ethel Grey Terry
Edwin Sturgis
Robert Broderick
Maude Turner Gordon
Lewis Stone
Shirley Mason
Malcolm MacGregor
Myrtle Stedman
Kalla Pasha
Natalie Kingston
Mario Carillo
Madeline Hurlock
Miss Béllie West
Jean Darnell
Miss Duncan
Baby Peggy
Lloyd Pryor
Benjamin Wright
J. A. Furey
Maury Steuart
Hassan Mussalli
William Williams
Robert Whittier
Charles Goodrich
Hattie Delaro
Mary Asquith
Alice Davenport
Myrtle Lind
Arnold Daly
MYRTLE GONZALES
G. M. RICKERTS
LAWRENCE PEYTON
GEORGE HERNANDEZ
JACK CURTIS
GRETCHEN LEDERER
JEAN HERSHOLT
MAUD EMORY
Mary Talbot
Charles Cummings
Dorothy Davenport
George Pearce
Eddie Barry
Mae Emery
Helen Lynch
GEORGE WALSH
Gloria Brooks
Fred Blake
Robert Brooks
Stanley Wharton
Valerie
John Beck
Edwin J. Brady
Rob Reeves
Gordon MacGregor
E. K. Lincoln
Dorothy Walters
Chas. Mussett
Edgar Norton
Dore Davidson
Elsie Ferguson
Marc MacDermott
Reginald Denny
Octavia Handworth
Caroline Vaughn
Ann Kroman
Joe Rickson
Fred Gilman
Antonio Moreno
Creighton Hale
Roy D’Arcy
Albert Gran
Paulette Duval
Max Barwyn
Charles Clary
Slim Summerville
Paul Parrott
Baby Early
Frank Butterworth
Eymour Hastings
Kathryn Griffith
Harry Sweet
Ralph McComas
Norman Kerry
Ward Crane
Arthur Earle
G. Butler Clonbough
Emil Hoch
James Laffey
Wm. Brotherhood
Fred Hearn
M.G. Ryan
Mabel Van Buren
GEORGE SIDNEY
LOUISE FAZENDA
VERA GORDON
Nat Carr
Helene Costello
Arthur Lubin
Jane Winton
William Strauss
MOLLY MALONE
CHAS. HILL MAILES
FREDERIC STARR
FRED MONTAGUE
JAMES GORDEN
Tom Wren
Agnes Kempler
Hilda Sloman
Agnes Vernon
Baby French
Jim Finlayson
Neal Burns
Bud Ross
Bill Blaisdell
George Soule Spencer
Ruth Bryant
Richard Wangemann
Ferdinand Tidmarsh
Gaston Bell
Charles Brandt
Adelaide Woods
Irene Hunt
Virginia Lee
Richard Ryan
Daniel Leighton
L. M. Wells
Mrs. Witting
Geo. Barringer
Barney Furey
Louis Goldenberg
Rene Verne
Jule Walters
Clara Armstrong
Grace Darmond
Walter Roberts
Frank Weed
Charles B. Hamlin
Tom Gallery
Dorothy Gulliver
John Peters
William V. Mong
Tom Foster
William Carlock
Harry Griffith
Doris Moore
Kate Fallon
Harry Leland
William Lake
Billie Reeves
Peter Lang
Charles Griffiths
Arlette Marchal
Edmund Burns
Adele Farringtion
Wyndham Standing
Hobart Henley
Adele Lane
Wm. C. Dowlan
Edward Sloman
BUD HARRIS
Lester Cuneo
Myrtle Stedman, Florence Dye
Rex de Rosselli
FANNIE WARD
JACK DEAN
PAUL WEIGEL
LILLIAN LEIGHTON
Mary Miles Milter
Roy Atwell
Jack Matheis
Warner Richmond
William Peavey
Haywood
Frank Robbins
Richard R. Neill
WALTER HIERS
Evelyn Francisco
Gayle Lloyd
Bill Armstrong
Virginia Sale
Sid Smith
Mary MacLaren
Jack Herbert
Guy Oliver
Sidney D’Albrook
DOROTHEA WOLBERT
Martin Ware
Violet McMillan
Mildred Adams
Clarence Burton
Eugene Walsh
HENRY KING
DOROTHY DAVENPORT
MOLLIE McCONNELL
GYPSY ABBOTT
MRS. McALLISTER
MADALINE PARDEE
CHAS. DUDLEY
ALBERT CHEVALIER
Mary Piper
Spottiswood Aiken
William A. Lawrence
Nellie Slattery
Frank Smith
O.A.C. Lund
Julia Stuart
E.Roseman
Lindsey J.Hall
Sydney Ayres
Val Paul
Doris Pawn
Seymour Hastings
Leah Baird
Charles Hutchison
Sheldon Lewis
Betty Howe
Mary Hull
Edmund Dalby
Austin Webb
William Cavanaugh
James Neill
Charles West
Marcia Manon
Jack Brammall
Jane Wolff
John McKinnon
Pansy Perry
Jennie Nelson
Charles Craig
Milton Sills
Viola Dana
Ruth Clifford
Rosenary Theby
Irving Cummings
Tom Kennedy
Hector Sarno
Lou Payne
Anna May Walthal
Edineh Altemus
Frank Leigh
Duke Lee
Charles Newton
Consuela Henley
Benjamin Corbett
Harry Loraine
Frances Ne Moyer
Billy Bowers
Mabel Paige
Raymond McKee
James Levering
Doris Kenyon
Charles Chaplin
GEORGE LARKIN
Arthur Johnson
Lottie Briscoe
Eleanor Blanchard
Howard M. Mitchell
Jack R. Hall
Josephine Longworth
Gilbert Ely
Mr. Einar Zangenberg
Claire Mersereau
Stanley Walpole
Joseph Granby
Helen Slosson
Bob Fisher
MABEL FORREST
KATE LESTER
WHEELER OAKMAN
MABEL TRUNNELLE
BRYANT WASHBURN
WILBUR HIGBY
FRANCIS POWERS
LAURA LAVERNIE
SYDNEY FRANKLIN
EDITH STAYART
BETTY SMALL
WM. J. IRVING
Fannie Ward
Jim Webster
Paul Byron
Horace B. Carpenter
Camille Astor
Gertrude Kellar
Jules Walters
Thomas Flynn
Jack Droumier
A. C. Marston
Hector V. Sarno
Mrs. LaVarnie
Marie Newton
E. Cecil
William Crane
Thomas Haig
Mrs. Haig
Peggy Haig
M. K. Wilson
DOLORES COSTELLO
JOHN BARRYMORE
Sam De Grasse
Holmes Herbert
Stuart Holmes
Bertram Grasby
Tom Santchi
Marcelle Corday
Templar Saxe
Eugenie Besserer
Rose Dione
Tom Wilson
H. Hum
C. E. Hodge
LEMUEL MOREWOOD
WILLIAM RUFUS MOREWOOD
THOS. JEFFERSON MOREWOOD
MAJOR BELLEMY DIDSWORTH
TOBIAS FORD
"TUCK" BARTHOLOMEW
BESSIE BRAYTON
EMILY DONELSON
FRANCES BERKELEY
S. Fairbrother
by Himself
Lewis Gilbert
Gwynne Herbert
Edna Flugarth
Douglas Fairbanks
Ruth Renick
Betty Bouton
Lew Fields
Amy Dennis
Wm. Fables
Frank Hamilton
Fred Eckhart
A Francis Lenz
Fannie Cohen
Mabel Bardine
Pat O'Malley
ZOE BECH
GEORGE HUPP
BEN HORNING
PAUL WEIGLE
NANINE WRIGHT
DOUGLAS GERRARD
Billy Bletcher
Eddie Baker
Jimmie Adams
Molly Malone
Kathleen Myers
Lincoln Plumer
Margorie Wilson
L.B. Gertrude McCoy
Crane Wilbur
Howard Mitchell
James Burns
Herbert Fortier
Rosetta Brice
Ronald Colman
Vilma Banky
Helen Jerome Eddy
Florence Turner
Jamie Gray
Charles Gerson
Billie Williams
Claire McDowell
Ceasare Gravini
Peaches Jackson
Sam de Grasse
Nellie Lane
Stan Laurel
ANN MERRICK
LILLIAN HAYWARD
GUY KNOX
EMMA BELL
Wm. V. Mong
Harry M. Holden
Nellie Allen
Frank Whitson
Annabelle Maurese
Sandy Brouke
Soda Water Manning
Molly Casey
Neely Edwards
Al W. Filson
George Hernandez
Cecil Van Auker
Millard Wilson
Lucy Payton
W.J. Spencer
BERT ROACH
Rodney Stanton
Stanley W. Barrows
Lee Kohlmar
Fred Hamer
Fay Holderness
Monte Montague
Jenks Harris
ANN LITTLE
ROBERT GORDON
WILFRED LUCAS
HARRY NORTHRUP
JACK LIVINGSTON
RHEA MITCHELL
ANDREW MACCLENNAN
MILDRED JUNE
"RED" KIRBY
GORDON MULLEN
LEW MEEHAN
Pearl White
Antonion Moreno
J. H. Gilmour
Paul Clerget
Peggy Shaynor
T. Webb Dillion
Mae Busch
Raymond Lee
Gladys Walton
Mo Kenzie
Gavin Dishart
Rob Dow
NORMA SHEARER
MARY McALISTER
CHARLES McHUGH
TINY WARD
MARTHA MATTOX
June Elvidge
Truly Shattuck
Lydia Yeamens Titus
Hallam Cooley
Thomas Jefferson
Aileen Munning
John Dooley
Gordon Dooley
GRACE CUNARD
EDWARD CECIL
HERBERT PRIOR
DORA ROGERS
Gladys Murgatroyd
Hazel Killian
Pete Kift
Jerry Murphy
Ben Warren
Gino Corrad
Thomas Meighan
Pauline Frederick
Ruth Hope
James Daggett
Gertrude McCoy
Robert Brower
Anne Leonard
Edward Boulden
Julia Calhoun
Earl Metcalfe
Augustus Phillips
Grace E. Stevens
Harry Linson
Charles King
Charles Doerty
Dolores De Lisa
Robert W. Frazer
Vincent Coleman
Helen Ware
Francis Puglia
Lois Tanner
Robert Spurier
Anna May Walthall
Butts Miller
CHARLES PUFFY
Gertrude Berkeley
Colonel Vernon
Mae McAvoy
Jobyna Howland
Hassard Short
George La Guerre
William Humphreys
CHARLES CLARY
GERTRUDE RYAN
BRUCE WILTON
YOUNG BRIAN KELLY
VERA WALLACE
SIDNEY SMITH
William Sadleworth
Edward O'Connor
Patricia Montez
John Duffy
Jerry Ash
John Featherstone
Mario Biannchi
PATRICIA SMITH
Louis B. Foley
Dorothy Sebastian
Ray Hallor
Pat Harmon
Alice Lake
Bud Duncan
Blue Washington
Sojin
THOMAS SANTSCHI
HARRY LONSDALE
BELLA RIDDLELL
Sally Tracy
CHAS. WHEELock
LAFAYETTE McKee
EARLE FOXE
ADDA GLEASON
Gertie Selby
Charles Conklin
Milburn Moranti
Jack Francis
H. Griffith
L. C. Shumway
Jack McHugh
Birdie Fogel
Tom Hicks
James Hertz
Dorothy Mackaill
John T. Murray
Yvonne Carewe
Dolores del Rio
Edwards Davis
Bob Hart
Yale Banner
Allen Crolius
Alice Forsythe
Edward Taylor
Bigelow Cooper
Dorothy Gish
Gibb McLaughlin
Henri Bosc
Marie Ault
Marsa Beauplan
Aubrey Fitzgerald
Cyril McLaglan
Nelson Keys
Benny Suslow
Geo. Berrell
Elizabeth Janes
Jack Nelson
Harry Von Meter
Wm. Gerwood
Leaves Eason
Bob Leonard
Marie Dunn
Edythe Chapman
Manuel R. Ojeda
Orral Humphreys
Jerry Brent
Manuel Corrales
Nick de Ruiz
Nigel de Brulier
Johnny Arthur
Evelyn Selbie
Mme. Nellie Comont
Paul Weigel
Earl Schenck
J. Farrell MacDonald
Kathleen O’Connor
Joe Girard
Sam Polo
Hilda Swanson
Jack Dill
Larry O'Keefe
Claire Du Brey
Alfred Allen
Helen Greene
Carrie Reynolds
GEORGE LEWIS
Wm. Franey
Chas. Conklin
Patricia O'Brien
Nora O'Brien
Richard Grey
Nance O’Neil
Frank Belcher
Robert Elliott
Agnes Eyre
Anna Raines
Alfred Hickman
Grace Gordon
Aubrey Beattie
Elsie Earle
Richard Dix
Marjorie Daw
Noah Beery
Lillian Leighton
Alice Brady
AL ALT
Estelle Bradley
Al Thompson
Eva Thatcher
Vincent Cullen
EMILY STEVENS
Arthur Frome
Herman Lieb
Frank Joyner
Evelyn Brent
Joe Daly
Evelyn Axzell
Laura La Plante
Robert Milasch
George Thornton
Charles Ranson
Henry Tomlinson
Edna Hamel
Mathilde Baring
Edith Lennon
Betty Fair
William Bechtel
Julian Reed
Cliff Hechinger
George Larkin
Mark Strong
Harry G. Moody
Frederick L. Kohler
Easter Walters
Allan Trainor
Lucille Lee Stewart
Anna May Wong
Josephine Norman
Theodor von Eltz
John Merkel
Cyril Ring
Edward Kipling
Milt Brown
Charles A. Stevenson
Naida Faro
Andy Clyde
A.L. Johnson
MR. B. ADLER
Harry Mestayer
Frank Archer
Anna Luther
Hugh Thompson
BARTINE BURKETTE
AUSTIN HOWARD
Hayward Mack
John Widder
Alice Treadwell
MABEL NORMAND
Louis R. Grisel
A. Romaine Callender
Monty Latham
Helen Dahl
Charlotte Granville
Willard Dashiell
Adella Barker
Duncan McRae
C. R. McKinney
Cecil Fletcher
Jack Raymond
James Humphrey
Ford OBeck
ED COXEN
MARION MURRAY
HELEN ARMSTRONG
GEORGE FIELD
JEAN DURRELL
CHARLOTTE BURTON
DAVID GREENWELL
ROBERT GREY
Murdock MacQuarrie
Mrs. Titus
Mr. Farjoen
Mark Fenton
Maude George
Yvonne Desmarest
M. Duroacher
Nanette
Dr. Emile Molleur
Ynez Seabury
George Siegramm
M. Lemond
Geno Corrado
Eloise Willard
George Welch
Roy Byron
Eva Bell
Miss Bell
Mrs. Carr
Margaret Fowler
Dick Conklin
Mrs. Fowler
Henry L. Bancroft
LeMoyne
Mrs. Bancroft
BETTY BLYTHE
Arthur Carewe
Huntley Gordon
Blanche Davenport
Billy Mason
Peggy Custer
“Mother” Ashton
ELSIE FERGUSON
Vernon Steel
George Fitzgerald
J. G. Gilmore
Cora Williams
Blanche Standing
Leslie King
Capt. Charles Charles
Mrs. Bryant
E. Girardot
Henry Warwick
Viriam Nesbitt
Mrs. Wallace Irskine
Laurie Irskine
Margaret Prussing
Jessie Stevens
ROY STEWART
Cliff Lancaster
Miriam Howell
Marion Murray
Albert Cavens
Aida Borella
Wm. J. Tedmarsh
Henry B. Walthall
U. K. Haupt
Victor Benoit
B. C. Turner
Julia Sanderson
Norman Trevor
Ada St. Clair
Dore Plowden
Jennie Ellison
W. H. St. James
James C. Malaide
Rose Trenton
Bancy Sanderson
George Trenton
Mrs. Trenton
Sandy Sanderson
George Prothero
His Secretary
Rose's Father
Her Mother
Mollie King
Dave Ferguson
Ruby Hoffman
Harold Entwistle
Dora Mills Adams
DOUGLAS MACLEAN
Helen Dale
Dick Baylss
John Howard
M. Archer, Sr.
MARY PHILBIN
MABEL MADDEN
TOM MASON
HARRY LOVERIN
Vera Steadman
Earl Rodney
Inez Marcel
Jack Stanley
Lila Lee
J. F. MacDonald
Mary McAlister
Ellis Paul
Phillip Humphreys
Vinnie Burns
Kenneth Davenport
Horace Morgan
Henry Russell
Ray Rust
Steve Stone
Madge Kennedy
Ben Hendricks, Jr.
Jack Meredith
WILLIAM SCOTT
LEE MORRIS
Mrs. Wallace Erskine
Marjorie Ellison
Yale Berman
John Sturgeson
Harold Lloyd
Robert Drouet
Peggy O'Neile
John Ince
Blanche West
Edgar Jones
John H. Smiley
Fred Tidmarsh
Clarence Elmer
Arthur Matthews
Robert Graham
William Carr
Francis Mann
Mildred Gregory
Nellie Craig
Albert Hart
Frank Quong
Rodney McKeever
GLADYS WALTON
Edythe Sterling
Charles Farrell
George Bancroft
Charles Emmett Mack
Mary Astor
Frank Hopper
Col. Fred Lindsay
Fred Kohler
Walter Ford
ANITA STEWART
Eugenie Besserei
John Hall
Calvert Carter
Billie DeVall
Maud Wayne
Ben Lewis
Will Jeffries
Marie Carlton
Harlan Keeler
Dr. Redding
King Carson
Jacqueline Logan
George Nash
Charles Beyer
Alice Howell
Bill Bevan
William Harcourt
Bessie Lane
Richard Thayer
Alta Allen
Bill Bradford
Jack Lane
Florence Mayon
Charles McHugh
George Lewis
Pat Chrisman
Henrietta Ethylyn Chrisman
Sid Jordan
Joseph Kilgour
Edward Connelly
Margaret McWade
Nancy Caswell
Franklyn Garland
Burwell Hamrick
Richard Headrick
Carol Jackson
John P. Morse
HELEN GIBSON
HOOT GIBSON
M. K. WILSON
G. RAYMOND NYE
SARAH MAITLAND
David Ritchie
Elizabeth Ferguson
Robert Ferguson
Christine Mayo
Syd Chaplin
David James
James E. Page
Priscilla Bonner
Warburton Gamble
Bijou Fernandez
Henry Stephenson
Julia Dean
William P. Carlton
Alexander Kyle
Helen Marlowe
William West
Frank McOlynn
Douglas MacLean
Wade Boetler
Katherine Lewis
Riley Hatch
JUSTINE JOHNSTONE
Helen Ray
Warner Baxter
Edna Holland
Jimmie Lapsley
Dan E. Charles
Grace Marvin
Emma Gerdes
Bobby Mack
Dick Smith
Jos. Moore
Pollard
Marie Mosquini
G. M. Anderson
Marguerite Clayton
George Hillar
Fred A. Kelsey
THEODORE ROBERTS
JAMES NEILL
ERNEST JOY
RAYMOND HATTON
MABEL VAN BUREN
TOM FORMAN
HELEN HILL
DR. BEITEL
LOIS MEREDITH
Edith Marbury
Wm. Bittner
Ed. Stanley
William Sullivan
Chas. Revado
E. P. Evers
J. W. Johnstone
O. A. C. Lund
Guy Hedlund
William Lugg
Bryan Powley
Hugh E. Wright
Pino Conti
ASHTON DEARHOLT
HAL COOLEY
JOSEPH W. GIRARD
HARRY DUNKINSON
WILTON TAYLOR
LOUIS W. SHORT
HELEN WRIGHT
Lillian West
George MacDaniel
A.
Howa
CJ
MARJORIE RAMBEAU
Hassan Musselli
Josephine Park
Sara Haidez
Ivy Duke
Hugh C. Buckler
Chin Ah Moy
PROF. J. C. HEEREY
BILLY ENGEL
LILLIAN BYRON
Elsie MacLeod
Anline Coughlin
Harry Gripp
Saul A. Harrison
Lizzie Conway
Tenor of the Metropolitan Opera Company
Lorenza Lazzarini
Margaret Loomis
Viora Daniel
May Baxter
L. J. McCarthy
William Winter Jefferson
Gilbert Coleman
George Staley
Samuel Hines
Dallas Anderson
Milton Boyle
David Young
Florence Stanley
Lorraine Frost
Rae Ford
Brinsley Shaw
Glen White
Mildred Manning
Wm. Welsh
Vivian Reid
Hal Cooley
Arline Pretty
Ned Reardon
Edward Duane
Harry Lonsdale
Winnifred Greenwood
Joe Hazelton
William Stowell
MME. PETROVA
Mahlon Hamilton
Arthur Hoops
Warren Oland
Henry Leone
Howard Messimer
Evelyn Dumo
Dorothy Mackmill
Richard Barthelmess
Nick Long
Marie Shotwell
Arthur Metcalfe
Warren Cooke
Jessie Pratt
Winter Hall
JANET BEECHER
DAVID POWELL
JOHN BRAND
ALBERTA GALLATIN
HENRY GSELL
GERALDINE MC CANN
Rapley Holmes
Robert Bclder
Lec White
MARGUERITE CLARK
O. W. Forster
Gladys Leslie
Charles Mussett
O C. Jackson
George Williams
George Routh
Helen Gibson
George Berrell
William Wedsworth
Saul Harrison
Herbert Abbe
nodore Alimonio
D.L.Don
Florence Williams
George Egan
Patsy De Forest
James Cassady
RICHARD BARTHELMESS
DOROTHY MACKAILL
ANDERS RANDOLF
PAT HARTIGAN
WM. NORTON BAILEY
BROOKS BENEDICT
COL. C.C.SMITH, U.S.A.
PAULINE NEFF
CHIEF BIG TREE
BILLIE BENNETT
FRANK COFFYN
CAPT. JOHN S. PETERS
TAYLOR DUNCAN
JACK FOWLER
E. W. BORMAN
BUD POPE
FORREST SEABURY
CHIEF EAGLE WING
Rae Godfrey
Agnes Neilsen
Carlyle Blackwell
Dion Titheradge
Myles McCarthy
Clyde Benson
Edward J. Brady
Helene Sullivan
Irene Yaeger
Pell Trenton
Edwin Stevens
Lawson Butt
Betty Hall
Evelyn Mc Coy
JACK RICHARDSON
PERCY CHALLENGER
Pat Whelan
Louise Owen
Walter Coyle
Clarence Barr
Grant Foreman
LEWIS STONE
BILLIE DOVE
LLOYD HUGHES
ARTHUR STONE
ARTHUR HOYT
BERTRAM MARBURGH
Jack Crarrymore
Fred Gambie
Mary Fuller
Elizabeth Miller
Robert Harvey
I. Lippner
Louella Maxam
Melle Provost
Mr. Escoffier
Lige Conley
Bobbie Burns
Peggy O’Neill
Blanche Payson
Doris Deane
John Sinclair
Eddy Polo
Laura Oakley
Thelma Percy
Ray Ripley
Arthur Jervis
C. Norman Hammond
EDDIE BARRY
VERA REYNOLDS
Mae Gaston
Beatrice Van
Duke Worne
Wm. T. Horne
Velma Gay
George Webb
John Lysaght
E. Clayton Blair
Audrey Williams
Monk Patterson
Olive Adair
Arthur Housman
May Abbey
Fontaine La Rue
Mable Van Buren
Fred Malatesta
Grace Morse
C.H. Geldart
Dorothy Messenger
James Smith
Samuel Framer
Charles A. Fang
Valentine Mott
Emily Chichester
Chas. K. French
Peggy Montgomery
William Hayes
Frank Merrill
Constance Crawley
Arthur Haude
RICHARD C. TRAVERS
Marguerite de La Motte
Joseph Swickard
Marcelle Daly
Percy Challenger
Buck Ravelle
Margaret Norton
Edgar Mason
Charles Slattery
Corey Williams
William H. Adsworth
Arthur Houseman
Lou Corey
WALTER HERS
TULLY MARSHALL
ADELE FARRINGTON
J. Gunnis Davis
Miss Hobbs
Alec. Francis Lamar Johnstone
Julia Stuart, Jriel Ostriche, Muton Cardow, Dace Kibbe, Alice Knowland, Julie Ambretta
Rod La Rocque
Elinor Fair
George Nichols
Sally Rand
Eddie Gribbon
André Tournneur
Hardee Kirkland
Girard Alexander
Joel Day
Dewitt Jennings
Mme. Petrova
J. W. Hartman
Mae Marsh
Allan Aynesworth
Aubrey Smith
Eva Moore
Herbert Langley
Hilda Bayley
George K. Arthur
A. G. Poulton
Tom Forman
R. Bradbury
Bob Grey
Bob Fleming
Stephen Carter
John Belmore
Preston Moore
BETH JOHNSON
Mae Hotely
Annie Whitlock
John Burke
Monte Blue
Wilfred Iytell
Diana Allen
J.H. Gilmour
John Miltern
Thomas S. Brown
Russell Parker
John Carr
Albert Hewitt
Eugenia Woodward
Wesley Jenkins
Grace Reals
Arnold Lucy
John Halliday
Natalie Talmadge
Fanny Bourke
Mrs. Nellie P. Spaulding
Martin S. Sitaro
James Spot
David K.
Monte Collins
Mary Brian
Charles Byer
George Irving
Jocelyn Lee
Tom Maguire
Frank Chew
Tetsu Komai
MISS JULIA DEAN
MARC ROBBINS
Ann Egleston
Alice Fleming
Charles Abbe
Malcolm Bradley
Paul Everton
Macy Harlam
Charles Hartley
Louis Hendricks
J. D. Walsh
CARRILLO
SELMA
BERTRAM GRASSBY
PRISCILLA DEAN
MAUDE GEORGE
HAYWARD MACK
EARLE PAGE
E.N. WALLECK
SEYMOUR HASTINGS
W. MITCHELL
Delores Hall
Frank Mac Quarrie
Flora Parker De Haven
Ed. Clark
Jack Tornek
WALLACE CAREY
ELSIE MITCHELL
MISS TOWNSEND
Norma Talmadge
Arthur S. Hull
Helen Ferguson
Lincoln Plummer
Thomas Ricketts
Warde Crane
Catherine Murphy
Dewitte Jennings
Vance Thomas
Roberta Daly
Walter Boynton
Thomas, Sr
W. H. Bainbridge
Anna Little
William Clifford
James Youngdeer
HAROLD LOCKWOOD
Za Su Pitts
Maria Donetti
Lugi Garrardi
Angelo Govanni
Tony Spezotti
Arthur Lake
EDWARD EVERETT HORTON
LYLLIAN BROWN LEIGHTON
SID SMITH
Reaves Eason
David Greenwell
Ted Duncan
Edward Hearn
Franklin Pangborn
Ethel Wales
R. Austin Webb
William Valentine
Jeanette Coff
Tom Dugan
George Ovey
Snub Pollard
Ray Gallagher
Harry Lampton
Gertrude Braun
Charles Vernon
Miriam Nesbitt
Rex Hitchcock
Ruth Findlay
Fred Truesdell
Scar Face
Nicholas Dunaw
Viola Benton
Edward Borein
JESSIE ARNOLD
R. BRADBURY
Walter Hier
Maym Kelso
Lew Moore
Richard Barthelmoss
Tom Ballantyne Jr.
Kate V. Tonoray
Carol Dempster
Berttram Grassby
David Haggard
Charles K.French
Mark Potts
William Elliott
William Worthington
W. Porter Chase
Katherine Weaver
Jane
Cyrus Holt
Douglas Maclean
Constance Howard
Cyril Chadwick
Wade Boteler
Mildith Peters
Frank A. Lyon
Nellis Grant
Edward O'Conner
Core Williams
Andrew J. Clark
Jess Willard
Charles J. Stine
W. C. Fields
James Kirkwood
CLAIRE
THE TRAGEDIAN
Lucille Ryan
Jim Kennedy
John Martin
Jane Bernoudy
Miss Hollenbeck
WALLY VAN
NITRA FRAZER
ALBERT ROCCARDI
TEMPLER SAXE
Virginia Corbin
Charlie Cummings
William Welch
Jane Tallent
Bert Apling
Clark Comstock
H. M. Lindley
Henry Stanley
Al St. John
Clem Beauchamp
Dan Leighton
Gertrude Aster
Charles G. Briden
Nanine Wright
Stanford Stone
Dorothy Maxwell
Kitty Rockford
Carl Weisner
M. C. Robbins
Blanche Mehaffey
John T. Prince
Noah Young
Sam Lufkin
Robert Page
Reggie Astorbilt
HARRY MYERS
Huntly Gordon
De Witt Jennings
Will H. Turner
Ed Faust
Edna Middleton
Ray Berger
Bob Elmer
Ben Walker
Jerold Hevener
Ed Lawrence
Mary Beth Milford
Dorothy Dorr
By Himself
Frank Austin
Tom Doyle
Kitty Doyle
Mrs. Doyle
James Kincaid
David Collins
Lem Morgan
Sally Morgan
Hale Hamilton
Mary McIvor
Marguerite Snow
Jessie De Jarnette
Howard Crampton
Ward Wing
Emmett C. King
Ruby La Fayette
Richard Barthelmes
PETER NEWBOLT
Robert Williamson
Virginia Magee
Lucia Backus Seger
Mary Alden
Juanita Hansen
Gertrude Selby
John H. Cossar
Eleanor Kahn
Jack Bartlett
Otto Crumley
Frances Burnham
Ralph Faulkner
Kitty Bruce
James K. Lee
Aunt Benson
Uncle Benson
Amy Trask
Harold Avery
Henry W. Otto
Al. Ernest Garcia
David Powell
Dorothy Cunnings
Richard Wangermann
Claude King
E. J. Brady
Douglas Gerrard
Audre Bailey
Bill Franey
Lawrence Gray
William Collier, Jr.
Lowell Sherman
Gail Kane
Vincent Serrano
Donald Reed
Jack Ackroyd
Ione Holmes
JACK HOXIE
Edwin Clark
Mrs. Erskine
Harry Bates
Ralph Lewis
Derelys Perdue
Eugenie Acker
Ernest C. Warde
John Fox, Jr.
Mary Jane Sanderson
Dell Boone
Billy Osborne
Robert Warwick
Louis Edgard
Ruth Mackay
Elisabeth Risdon
Charles Rock
FLORENCE VIDOR
El Brendel
Irma Kornelia
J. Warren Kerrigan
Hazel Burkham
Robert A. Myles
Buck Connors
NORMAN KERRY
GRETA NISSEN
Edith Johnson
Spencer Clark
Carroll Nye
Charles Murray
Jacqueline Wells
George Sidney
William C. Dowlan
William Quinn
Violet MacMillan
William Wolbert
Doc. Crane
Melvin Mayo
Velma Whitman
Lyle Phelps
Jack Wilson
Ben Bostwick
Alice Malone
Larry Malone
"Chip" Stevens
WM WELSH
NOBLE JOHNSON
VIVIAN REID
BUD OSBORNE
E. K. LINCOLN
F. B. Phillips
Tully Marshall
Coy Watson
Gertrude Norman
Milla Davenport
Niles Welch
Beth Kosick
Leonard Clapman
Wm. Suowell
Hal Dart
Marion Warner
VESTA PEGG
BETTY SCHADE
M.K.WILSON
MARTHA MATTOK
STEVE CLEMENTO
Kitty Harigan
Jim Harrigan
Hayden Delmar
Tim Murphy
Charlie Parrish
Bradley P. Caldwell, Jr.
Bradley P. Caldwell, Sr.
June Daye
E.K. Lincoln
F. M. Wells
Jack Wells
Jim Graham
Davy Don
JOE ELIOT
Norris Millington
Joyce Fair
Helen Bauer
William Fables
Michael Carroll
Dan Baker
Robert Schable
Edith Yorke
Genevieve Fowler
Frank Clarke
Herbert Bawlinson
William Hutchinson
Anna Dodge
Eddie James
Charlotte Stevens
Wm. J. Irving
Lillian Hackett
Holbrook Blinn
Madge Evans
Gerda Holmes
Lon Gilchrist
Bud Dalton
Del Beasley
Helen Wolcott
Jaque CATELAIN
VANNI - MARCOUX
Helles Marcelle PRADOT
Philippe HERIAT
LERNER
Johanna SUTTER
Lucy Dayton
Reggie Morris
Louise Orth
MARY MILES MINTER
Thomas J. Carrigan
Daniel Hegan
Herbert Hayes
Jules Rancourt
Sidney D'Albreek
Harold Hilton
Louise Vale
Franklin Ritchie
George Morgan
J. K. Roberts
Wm. Jefferson
Stanley Taylor
Robert Strickland
Barbara Castleton
James Young
Corene Uzzell
Mary V. McAlister
Max Hofer
Paul Marsh
Jack Gordon
Tom Markham
Oliver La Baddie
Wallace Baker
Andy Hicks
J. A. West
Joseph C. Portell
Hubert La Baddie
Corydon W. Hatt
Walter Orr
Ernest Blasdell
Stephen Geitz
Mrs. J. Montgomery
Flora Arline Arle
Mildred Harris
Richardson Cotton
Randall McAllister
Fritzi Brunette
Florine Garland
John Prescott
Joseph Massey
Warren Kerrigan
Phyllis Gordon
Kittoria Beveridge
Charles Fortune
Halbert Brown
Louis Dean
George Riddell
Frank Stone
Carl Dane
Fred Hern
Percy Standing
William Bittner
Arthur C. Duvel
Clarence Jay Elmer
Marie W. Sterling
Percy Winter
Luella Carr
Flora Lea
Edwin De Wolff
William Rauscher
Carol Halloway
Jack O'Neil
Tom Carr
Dorothy De Wolff
William Fairbanks
Eva Novak
Frankie Darrow
Ruby Lafayette
David Lythgoe
Jimsey Mayo
Jack Hoxie
Benjamin Wilson
Charles Button
Thomas Haverley
Margaret Lane
Clerk Crane
Land Gaige
Marie Doro
Charles Mailes
Elwood Bredell
Mignon Anderson
Ed Brown
J. Morris Foster
Wadsworth Harris
Peggy Shaw
Jack Dillon
Claire Anderson
ALLENE RAY
Walter Miller
Frank Wunderlee
Frank Lackteen
Ivan Linow
Albert Roccardi
Gordon Bennett
Jean Brodie
CARLYLE BLACKWELL
HORACE B. CARPENTER
FRANK ELLIOTT
MIGNON ANDERSON
Jackie Coogan
Gladys Brockwell
Edouard Trebaol
Taylor Graves
Lewis Sargent
James Marcus
Florence Hale
Joseph M. Hazleton
Lloyd Bacon
Harry Todd
Gate Henry
Bob Vernon
Duke R. Lee
Owen O'Neal
Phillips Smalley
Rupert Julian
H. Scott Leslie
Bert Honey
Evelyn Greeley
Kate Lester
Kitty Johnson
A. Black
Herbert Barrington
Marguerite Clemens
Barbara La Marr
William Eugene
E. L. Calvert
Mathilde Comont
Edward Piel
Nicholas de Ruiz
Hiram
Besse E. Wharton
Lee Roy Baker
Jane Galvin
John Barth
Mr. Galvin
Milton Vanderpool
Lena Genstyou
WALLACE MACDONALD
Johnny Hines
Edmund Brees
Mildred Ryan
J. Barney Sherry
Bradley Barker
Charlotte Dawn
Al Ray
Tom Harvey
Grace Harvey
Leonora Carewe
Her Companion
Victor Potel
Wan Duffy
Teddy Martin
George Barrell
G. Raymond Nye
Hazel Buckham
Edward Devlan
Vera Walton
Tom Devlan
Vera Reynolds
Henry Walthall
Don Marion
Dolly Martin
Jim Watson
Charles Martin
Bud Harris
Pauline Curley
Jay Dwiggin
Fred Burns
Lafe McKee
Winifred Landis
Buddy Roosevelt
Robert Homans
Charles Whitaker
Al Taylor
Jack Ford
Howard Daniels
Harry Schumm
Gladys Tennyson
Marjorie Ray
Margaret Marsh
Charles Dalton
Charles Trowbridge
Donald Gallaher
Mae Cooling
Vernon Steele
Maxine Elliott
Bill Ryno
Eddie Sutherland
Charles A. Smiley
C. L. Sherwood
Fatty Arbuckle
Eleanor Van Nuys
Lincoln Stedman
Hal Wilson
William Dyer
Harry Mann
MAE MURRAY
CKASSON FERGUSON
MRS. GRIFFITH
CLARISSA SELWYN
FLORENCE CARPENTER
Virginia Lee Corbin
Elliott Nugent
Harry T. Morey
Ruby Blaine
Colleen Moore
James Morrison
Eddie Phillips
Ruth Hiatt
Mary Ann Jackson
Geo. Beranger
T. Du Croe
Togo Yamamoto
Alice Wilson
Barry O'Moore
John Quinn
Merta Sterling
Charles Inslee
Al Gerald
Pearl Waldon
Harvey Gresham
Haynes Waldon
Helene Chadwick
Leo Maloney
Whitehorse
Bud Osborne
Tommy Grimes
Ted Wells
Lotus Thompson
Jimmy Phillips
Charles (Slim)Cole
George Ovey)
Dick Le Strange
Eugene O'Brien
Mae Buscu
Ben Alexander
Mitchell Lewis
Bebe Daniels
Chuck Reisner
ETHEL BARRYMORE
E. J. Ratcliffe
H. E. Herbert
Naomi Childers
John Goldsworthy
Maud Turner Gordon
Harold Entwhistle
Eugene Strong
Edna Robinson
Leona Anderson
Fay Reynolds
Wadsworth
Rance
Miss Mattox
McNaughton
Dorothy Brock
Dorothy Revere
Richard C. Travers
Phillips Shalley
Jere Austin
Lon Tellegen
Miss Gail Kane
Mr. Vernon Steel
Mr. Ned Burton
Miss Clarissa Selwynne
Mr. Lawrence Grattan
Mrs. Julia Hurley
Mahlon Har
Crauford Kent
Charlie Murray
Wayland Trask
Mary Thurman
Gene Rogers
Earl Kenton
Madge Bellamy
Tom Guise
Audrev Chapman, Dorothy Manners
MAY MCAVOY
WILLARD LOUIS
Gardner James
Vera Lewis
Nora Cecil
William Herford
Alexander
Ross
Kerr
Boyd
Ann Drew
Miss C. Henry
Frank Bacon
BILLY SULLIVAN
Margaret Joslin
Olive Hasbrouke
CLEO MADISON
Marion Leslie
Rance Clifford
Blanche White
Wedgewood Howell
Albert McQuarrie
Rhea Haines
Ruth Harkness
Willard Masten
Rex Randerson
Anna Clifford
Allan Crollius
ARTHUR TRIMBLE
John Smiley
John E. Ince
Eleanor Dunn
William Cohill
Justina Huff
Alan Haliday
Claire Dean
Wes McQuinn
Brack McQuinn
Nitchamoose
Ogoma
Lillian Devere
Harry Scherr
John Walker
Edward Lawrence
Frank A. Lyons
Will Brandon
James Brandon
Mrs. Brandon
Seth Baldwin
Ted Baldwin
Mr. H.B. Warner
Miss Violet Heming
Mr. W. Lawson Butt
Mr. Arthur Donaldson
Mr. Arthur Cozine
Mr. H. Howard
Mr. Wm. Cooper
Mr. S.M. Unander
Duncan MacRae
Yale Boss
WILLIAM HAINES
DOROTHY DEVORE
FRANKIE DARROW
DAVID TORRENCE
SHELDON LEWIS
WILLIAM WELSH
CHARLES MURRAY
Bobby Boldex
Wilfred Rogers
Gilmore Hammond
Kathleen Aamold
Edith De Velmeseda
Max Sargent
Jane Keckley
Myrtle Vane
Samuel Allen
Cleo Rand
Gloria Marston
John Marston
Ray Griffith
LARRY CASSIDY
WALLIE MASON
VAN ARLAND
BERYL
VIOLA MATTHEWS
Art Ortego
Lulu B. Jenks
Otto Nelson
Betty Scott
Philip Pharo
Dustin Farnum
Winifred Kingston
Howard Davies
Colin Chase
Ogden Crane
CHARLES KING
EMMY LYNN
JEANNE BRINDEAU
JEAN TOULOUT
ROMUALD JOUBÉ
ANDRÉ DUBOSC
DECŒUR
William Machin
Bessie Love
Gareth Hughes
Otto Lederer
Gertrude Clair
Sam Allen
William Lawrence
Thomas Santschi
Billie Dove
Ben Lyon
Laska Winter
T. Roy Barnes
George Kotsonaros
Charles A. Post
August Tollaire
Yola d'Avril
William Orlamonde
Jack Lockney
Mildred June
Ethel Teare
Bobby Dumm
Harry Kenneth
Romaine Fielding
Peggy Brown
Mary Applewin
Joy Winthrop
Jeff Daggett
Helen Foster
Johnny Fox
Irving Bacon
Polly Moran
Charles Lynn
Al McKimmon
MAE MARSH
JACK MCLEAN
ARTHUR HOUSMAN
MATT MOORE
EDWIN STURGIS
HENRY HALLAM
Woodrow
Robert Lane
Rose Lathan
Barbara Baxter
Jack Luden
Grant withers
AL COOKE
KIT GUARD
Yvonne Howell
William Martin
Johnny Gough
GEORGE DAVIS
JACK McHugh
IRENE RICH
CONWAY TEARLE
Gustav Von Seyffertitz
John Miljan
Emile Chautard
N. Vavitch
DAN MASON
Wilna Wild
Helen Gerould
William Randall
Irma Irving
Charles Giblin
Julanne Johnston
Zoe Rae
Mary Hanley
Arthur Shirley
Lon Chaneu
Marcia Moore
L.C. Shumway
Margaret Crytting
W.W. Campbell
Fred Normes
Fred Adrath
James Rosen
Harry Meyers
Marguerite Clark
Florence Carpenter
Frank Losee
Phil Riley
Harry Lee
Walter Lewis
Augusta Anderson
Henry Stamford
Susanne Willis
Mrs. Priestley Morrison
Thomas Carnahan, Jr.
RALPH INCE
Walt Robbins
H.J. Jacobs
Joseph W. Smiley
Gladys Hulette
Walter P. Lewis
Ralph Bausfield
Forrest Robinson
Laurence Eddinger
Edmund Gurney
Marion Abbott
Harry Hallam
Charles H. Martin
Robert Kegerreis
Eldean Steuart
Loel Steuart
Harry Eytinge
Bob Harvey
Arnold Prisco, Brad Sutton
ELISIE GREESON
HUGH VERNON
Pedro De Cordova
Vera Beresford
Mrs. T. Randolph
Rex McDougall
J.P. Laffey
Emma Ray
George Dumont
Mrs. J. H. Brindage
Miss McGrae
Tina Marshall
PETE MORRISON
Flora Le Breton
Edmund Breeze
Coit Albertson
Cornelius Keefe
Jack Henry
John Sheehan
Bessie Banks
Dixie Stewart
Edna Maison
Phyllis Daniels
O. C. Jackson
Marjorie Lake
Billy Sheldon
Dick Lang
Grace Ellis
Mr. J. G. Davis
Mr. Alec. Francis
Miss Muriel Ostriche
Henry Murdock
Mattie Comant
Lillian Peacocke
Jack Conally
VIVIAN MARTIN
Robert Ellis
Arthur Allardt
VESTA BORIS
JACK HOLT
NOAH BEERY
George Trimble
Jeff Healey & Frank Smiley
Bartley Mc Cullum
Baby Marie Osborne
Alice Saunders
Louis Hahn
Ed Hearn
Vivian Martin
George Ralph
Lawrence Ashmore
Jesse Craven
Edith Craven
Richard Creelman
R. Whittaker
Mrs. Maurice
Tom Santachi
Kitty Gordon
Billy Dooley
Amber Normand
Knox Dunlap
Mary Scott
Jane Shafer
Adolphe Jean Menjou
Wedgwood Nowell
Otis
John Vincent
Arthur Millet
Fred Smith
Jackie Levine
BLANCHE SWEET
EDYTHE CHAPMAN
ELLIOTT DEXTER
James Cadman
Eleanor Cadman
David Lee
Henry Neville
Wallace Berry
Courtney Foote
Howard Truesdell
Jeanne Carpenter
Andre de Beranger
James Colley
Boyd Irwin
Murdock McQuarrie
Hector V. Samo
Lucy Beaumont
Mary McAllister
Kenneth Gibson
Rush Hughes
Harda Daube
Jack Kane
James Crowninsheild
Jeanette Horton
Margaret Linden
Wallace Mc Cutcheon
William Eville
William Gaunt
Harry Hytinge
Jean Dumar
O.H. Hardy
Marie Standlaw
Louis J. Cody
Mildred Montrose
William Nordly
Seena Owen
Edward Farrington
Zoe Bech
Richard Bennett
Clara K. Young
J. Rodney Sherry
Jack Daugherty
Mme. Olga Petrova
Thomas H. Holding
Lucille LaVerne
Matilda Burndage
Sarah Harden
Richard Courtland
E. J. Burnes
Florence Robert
Edith Hinckle
Gene Burnell
VICTOR MOORE
Joe King
Charles Giblyn
Robert Brewer
Brad Sutton
Natalie Joyce
PHILLIP SMITH
MOLLY
MRS. SUTHERLAND
JACK HERRICK
DR. ALLEN
JACK HUTCHINSON
DOUGLAS FAIRBANKS
Herbert Grimwood
Kathleen Clifford
Daisy Robinson
Louise Huff
Francis McDonald
Thomas Rickertts
Edward Kennedy
JOE GIRARD
VICTOR KING
Robert Milash
Danny O'Shea
Al Cooke
Frankie Darro
Gene Stone
Betty Caldwell
Shameless Salverson
Harry Told
Jim Bludsoe
Edwin Wallock
Harold Montaine
Farmer Meadows
Dennis Casey
Tom Dalton
Al Wilson
Anita Stewart
Rose Tapley
W. von Brincken
Wm. von Hardenburg
PAMELA MARTIN
Frank Steele
Douglas Martin
Mrs. Stanley Cartwright
Mrs. Alicia Temple
Gilbert Martin
Helen Lindroth
Maud Hill
Oliver Hardy
RUDOLPH VALENTINO
Paulette Du Val
John Davidson
Oswald Yorke
Lewis Waller
Ian MacLaren
Frank Shannon
Templar Powell
Downing Clarke
Yvonne Hughes
Florence O’Denishawn
Violet Mersereau
Fanny Hayes
William Garwood
Lionel Barrymore
Doris Rankin
Ralph Herz
George Pauncefote
Irene Howley
Gretchen Hartman
BARBARA LA MARR
FLEUR FORSYTE
Miss Carol Dempster
W. J. Ferguson
Edward Peil
Porter Strong
Charina Slattery
George Neville
Tyrone Power
Morgan Wallace
Herbert Chalfin
E.C. Taylor
Howard Anderson
John Talbot
Katherine MacDonald
Edmund Lowe
Howard Gaye
Lenore Lynard
Hellena Phillips
Junior Coghlan
May Robson
Elise Bartlett
Mrs. Chas. Mack
Joseph Striker
Adele Watson
Lillian Harmen
Bobby Heck
W. E. Lawrence
Mrs. G. Hernandez
Virginia Brown Faire
Maxine Brown
Eugene Lockhart
Joe Ryan
Ed Jones
Catherine Gohl
Helen Armstrong
Reaves Kason
Frank O’Keif
Marie Wierman
Minnie Mordock
Jack Ridgeway
Henry Wesbert
Marie Prevost
George O’Hara
Fanny Kelly
Billy Armstrong
Kenneth Harlan
Jerry Miley
Charles Sellon
Zack Williams
Richard Carle
Mildred McOre
Gus Pisley
David Lythgo
Harry VonMet
Peggy Provost
Harry S. Griffith
Alice Beice
Ernest Van Pelt
Ervin Denneke
Al Ernest Garcia
Dorothy Roshar
J. M. Dumont
Luke Warm
Isadore Able
Butt Insky
Fuller Fat
Shakespeare Clancy
Alice Whitney
Lew Morrison
Wilbur Higby
Monty Collins
Helen Fulton
Mae Forsythe
Richrd Grant
John Royce
James Harker
Fay Raye
Lucian Littlefield
HENRY SEYMOUR
MRS. SEYMOUR
ELMER SEYMOUR
LOLA SEYMOUR
HARRY SWEET
Lillian Wade
Audrey Littlefield
Lorraine Pardee
Roy Clark
Wm. Hutchinson
Louise Dunlap
Irma Bagsdale
Janette Pardee
Fred Chandet
Margarita Loveridge
Frank Clark
Emil Jannings
Dagny Servaes
Henry Liedtke
Paul Biensfeldt
Albert Bassermann
Paul Wegener
Lyda Salmonova
Friedrich Kuhne
PAT ROONEY
NEAL HART
Edward M. Kimball
Carol Blair
Wesley Jamison
ALBERTA VAUGHN
LARRY KENT
Ben Hendricks, Sr.
Agnes Marc
Paddy McQuire
Richard Buhler
Craufurd Kent
Inez Buck
Karva Poloskova
William Turner
Miss Denise Maural
Mr. M. Colbert
Mr. Dessandix
Miss Josette Andriot
Mr. Delmonde
Mr. Dartagnan
Mr. Jordans
Jacques Paganal
John Sherman
Margaret Moore
Willam Cohill
Florence Hackett
Jack Westley
Gloria Hope
Jack Dillion
Mr. Guise
Roberta Wilson
Charles Pearley
Myrtle Gillette
BERT LYTELL
Robert Dunbar
Wilton Taylor
George French
WILLIAM DESMOND
GARETH HUGHES
Ethel Grandin
Margaret Mc Wade
Graham Pettie
Frank Norcross
Walter Perry
Eileen Hume
Eric Layne
Effie Conley
Peter von Helm
Margaret
Miss Winton
Mr. Franklyn
Tom Carrigan
Kenneth Hill
Frank Doane
Zelda Sears
Horace Haine
Arthur Moore
Joe Räck
Gertrude Claire
Fred Butler
Clara Kimball Young
Katherine McGuire
Edward Kimball
Louise Brooks
Josephine Drake
Roger Davis
Hugh Huntley
Elsie Lawson
Johnny Ray
John Ovens
George N. Chesebro
Ed. Brady
Margarita Fisher
P. Dempsey Tabler
Evans Kirk
Joseph Bennett
Margaret Livingston
Lloyd Ingraham, Lillian Elliott
Alan Roscoe
Philo McCullough
Mervyn Leroy
Eve Southern
Jim Wallace
Bess Ames
Chester Withey
Joe Harris
Jack Walters
William Cartwright
WM. STOWELL
MRS. LINNE
C. C. HOLLAND
John Lorenz
Arthur Bates
Matty Rupert
Lois Alexander
Wanda Wiley
Rita Carewe
Helen Royerson
Ormi Hawley
Ed Wynn
Thelma Todd
Robert Andrews
John Harrington
Linnie Carter
Finita De Soria
Joe W. Girard
Clifford Gray
Emil Hack
Malcom MacGregor
Gladden James
Wilson Benge
John Cough
Jacques Alleyne
Mme. d'Esterre
Paulette Del Baye
Lottie Pickford
George Periolat
Orral Humphrey
W. J. Tedmarsh
Jose Collins
Arthur Donaldson
MR. BARKER
ARMAND CORTEZ
ELIZABETH CARTER
Ernest Stallard
Charles Dickson
Alfred Kappler
Arthur Lewis
Pearl Bowne
Margaret O'Mears
Greta Garbo
Roy D'Arcy
Armand Kaliz
Robert Anderson
Inez Gomez
Steve Clemento
Roy Coulson
Zoe Ballentyne
Dudley Holt
Betty Brown
Mrs. Emily Ballentyne Morse
Charles Bryant
M.E. NAZIMOVA
E. L. Fernandez
John Reinhard
Louis Stern
Charles Eldridge
Liliriam Battista
Harry Fox
Grace Darling
Mae Hopkins
Doris Baker
Louis Fitzroy
Eleanor Blevins
Helen Eddy
Julia Mathews
John Mathews
James Goodwin
Billy West
Ethlyn Gibson
Bobby Mason
MONTY BANKS
RICHARD STANTON
GLEN WHITE
Mary Carr
William Hunphreys
Madge Joy
Robert Chandler
Phillip Sleeman
STAN LAUREL
Tom Warner
Vicky Mason
Al Alt
Clarence Geldart
Marietta Millner
Duke Martin
Charles Hill Mailes
King Zany
“Gunboat” Smith
Tom Tyler
Lucille Rogers
Boans
Harry Woods
Frank Rice
Tom Lingham
Jack Anthony
Doris ...........: Eileen Sedgwick; Bruce .........: George Cheseboro
Alfred Fisher
Mr. Gouget of the Grand Guignol
Mr. Bahier of the Odeon
RAMON NOVARRO
Harriet Hammond
Wesley Barry
Margaret Seddon
Crawford Kent
Pauline Neff
Kathleen Key
Maurice Ryan
William Boyd
Sadie Simon
Louis Simon
Harry Hilton
Frank Cooley
Gladys Kingsbury
Armand Kalisz
Grace Henderson
Clio Ayers
Reginald Carrington
Stephen Van Dyck
Daphne Purcell
Tom Stanhope
Willie Bergh
Johnnie Walker
Mrs. Wallace Braskine
George Ramsay
Ethol Clayton
Dora Collier
Hilary Collier
Craig Spaulding
Kenzel Ernstedt
Violet Van De Wart
Cecil Atherton
T. Jay Barnes
Franklyn Bauer
Wilfred Glenn
Lewis James Elliot Show
Frank Black
Alice Schuyler
John Carmen
Mrs. Schuyler-Foster
Mr. Schuyler-Foster
Harrison Thornby
Mrs. Dahlgren
Cumberland Whipple
Martha Whipple
Chorus Girl
FRED HUMES
Ben Deely
Harry Fenwick
KATHRYN McGUIRE
RICHARD TALMADGE
ARTHUR RANKIN
MARCELLA DALEY
John Fownes
Ellen Ingram
Gladys George
Clair MacDowell
Raymond Cannon
Al Filson
George M. Wright
Norman McKinnel
Lilian Braithwaite
Odette Goimbault
Kathleen Kirkham
Harlan Tucker
William Conklin
Lydla Titus
William Musgrave
Joe Campbell
BENNY LEONARD
WALTER HORTON
STUART HOLMES
BERNARD RANDALL
RUTH DWYER
MME. MARSTINI
MARIE SHOTWELL
C. M. Hallard
Madge Titheradge
Campbell Gullan
Al Green
Gordon Sackville
Irene Norris
Dick Taylor
Poncho
Sidney Drew
HORACE DAVEY
PAUL RUSSELL
DIANA GORDON
KEITH GORDON
MARJORIE GORDON
HOUSE PETERS
MYRTLE STEADMAN
J. W. JOHNSTONE
HELEN JEROME EDDY
Gerald Gray
Betty Kane
Si Clegg
Walter Belasco
Charlotte Minneaux
Leelie King
James Bradbury
Hugh Saxon
Esther Rhoades
Montague Shaw
William Carroll
Sidney Hayes
Georgia Sherart
W.E. Parsons
John Ebarts
Bliss Milford
Dwight Crittenden
Bert Sprotte
Vic Potel
Bud Post
Jessie Arnold
LESLIE KING
KATE BLANCKE
EDWARD EARLE
BARBARA CASTLETON
WILLIAM RUSSELL
Barbara Bedford
Rex Lease
LON CHANEY
Buddy Messenger
Arthur Mathews
Herman Seigle
Florence McLoughlin
Frankie Mann
Enid Bennett
Makato Inokushi
Joe Bennett
Jack O’Brien
Dick Lareno
M.E. Ryan
Wm. Courtright
June Keith
Thomas McLarnie
Arthur W. Bates
Sam Cramer
Yvette Guilbert
Phillip Fordyce
John Bradley
Carl Bohm
Mary Fordyce
Mrs. William Farnum
Dolores Cassinelli
Lorna Duveen
Andrea
Vivia Ogden
J. Moy Bennett
Lena Baskette
WARNER OLAND
Flobelle Fairbanks
William Demarest
Hugh Allan
Cathleen Calhoun
Jean Lefferty
Rapp
Helen Morgan
Tom Morgan
Geo. A. Dayton
Wm. C. Carlock
Mrs. Carrie Fowler
Mrs. L. Y. Titus
Renee Adoree
Wm. Brunton
Eunice Moore
Nina Byron
Dorothy Britton
Arthur Stewart Hull
Camille D'Arcy
Carson Burr
Nicolai Poppoff
Emma Reich
Theodore Burr
Lucile Young
Albert Ebrate
Rose Morris
Ed Harley
Lois Moran
Allan Simpson
Richard Arlen
Douglas Fairbanks, Jr.
Charlot Bird
Charles Delaney
Tom O'Brien
Alfred Drayton
Joan Beverly
Gayne Whitman
Otto Matiesen
Lucas Rymer
Jane Doolittle
Jim Roberts
Jim Gibson
Ray Hampton
Stella Razetto
Jennie Filson
Mr. Pietro Sosso
Mr. Cecil Holland
Lucile Hutton
Victory Bateman
Ann Carmichael
Violet Heming
Edwin Mordant
Ralph Kellard
Ed. Arnold
Carlotta Monterey
Mrs. Jane Jennings
Florence McGuire
PIE READ
Sidney Sellers
Bennie Byers
Hazel Page
Sp ed" Meredith
Virginia Allen
Regan
Teresa
Bub Allen
Sims
Sam Lee
Burke
Claire de Lorez
Henry J. Hebert
LAMAR JOHNSTON
JACK MCDONALD
FRED HUNTLY
Frank Lloyd
Heley Haynes
Bobby Bates
MacGregor
Guy Bates Post
Ruth Sinclair
Herbert Standing
Gustave Von Seyfertitz
Charles P. McHugh
William H. Keith
Ruth Allen
Fred Goodwine
David Porter
Bull Montana
Steve Murray
Beth Roland
Lydia Y. Titus
Johnny Jones
Nick Cogley
Virginia Madison
Lucille Ricksen
Cordelia Callahan
Lucretia Harris
Charles Meakins, Jr.
Harry Penn
Louise Fazenda
Sidney Chaplin
Sherman Bainbridge
Robert Randall
Wm. Tedmarsh
Slim Paggett
Evelyn Selbin
Jack Woods
Gilbert Roland
Lilyan Tashman
Oscar Beregi
Albert Conti
Michael Visaroff
Etta Lee
Norbert Myles
Lady Tsen Mei
Sterling Holloway
Sydney Jarvis
Anna Mae Walthall
Arthur Koeppe
Dorothy Barrett
Richard Stanton
Jane Novak
Jack Stevens
Mark Gramble
Joe Singleton
George Arliss
Mrs. George Arliss
Margaret Dale
Henry Carvill
Grace Griswold
Noel Tearle
Fred. J. Nicholls
John Boyle
Edwin August
Mrs. Kimball
Ed. Kimball
Silas Feinberg
PEGGY SHAW
Karl Silvera
Ruth Royce
SHAD GOULD
CRAWFORD SMITH
RASTUS YOUNG
JUDGE BAXTER
MR. BACHELOR
ISAIAH
John Cranford
Michael Smead
Donald
Fred Wilson
Elizah Zerr
RUDOLPH CAMERON
THOMAS HOLDING
MARGARET LANDIS
HALLUM COOLEY
JOHN P. LOCKNEY
CHARLES BELCHER
Gertrude Glover
Tom Webber
Leota Chrider
Edna Hunter
Wallis Clarke
Beatrice Allen
MAY ALLISON
Zeffie Tillbury
William Elmer
Arthur V. Johnson
Florence Lang
May Ashton
OLIVE BARTON
PETER BARTON
LEONARD HEWITT
ALVIN THORNE
'HIGHBALL' HAZELITT
'THREE GUN SMITH'
KATE PRICE
OLIVE TELL
William J. Kelly
John Daly Murphy
Marie Wainwright
Hugh Jeffrey
Bert Tucy
John A. Smiley
Barbara Winthrop
George M. Cohan
Russell Bassett
William Walcott
Ann Cornwall
Bobby Vernon
Jay Belasco
Wm. E. Parsons
Richard E. Enright
Jack Howard
Richard Bartholmess
Clarine Seymour
Eugenie Resserer
Ralph Craves
Fawcett
Haines
Lestina
Sutch
Warner
Gordon McGres
Edith Robetrs
Hugh Herbert
Patricia Caron
Guy D'Ennery
Jaques Rollens
PAULINE FREDERICK
John Alden
Louis Sterns
Florence Ashbrooke
Florida Kingsley
Maurice Costello
Thomas J. McGrane
Olga Olonova
Wm. H. Cavanaugh
John Milton
N. J. Thompson
Basil Sydney
May Collins
Olive Valerio
Unknown
Frank Lalar
Steve Brant
Cal Hearn
Chas. Gerrard
Chas. Le Moyne
Will Machin
Joan Allen
Richard Heath
Ralph Allen
Muriel Heath
Bobby Allen
Patsy Heath
EDNA FLUGRATH
Zena Keefe
Frank Evans
DOROTHY DALTON
Chas. Burbridge
H. Haley
Frances Nelson
Natalie Raydon
Richard Sterling
Chandler House
Lillian Cook
Robert Cummings
George MacQuarrie
George Walsh
Jane Jawley
Edward Soulden
Lizzie Weldon
Ned Hargraves
Joe Mitchell
Ethel Broadhurst
Doris Whitney
Verda Crane
Jack Ramsey
Villa Dana
Allen Forrest
Lillian Lawrence
EDGAR SELWYN
MILTON BROWN
BILLY ELMER
SYDNEY DEANE
GERTRUDE ROBINSON
PARK JONES
Bobbie Dunn
Russ Powell
Catherine O’Connor
Sophie Clutts
Rod LaRoque
LEWIS SARGENT
Jack Gleason
Jim Whann
Ethel Whann
Mr. Whann
Eugenia Silbon
John Winters
Charles Gunn
Ann Ivers
Alf. Goulding
Frank Lyons
Ira Dewberry
Mary Mandrake
Flossie Flatter
Jack Dawson
Burt I
Bobby M
BOB HUNTLEY
Gladys Hanson
Hal Forde
E Cooper-Willis
Nina Blake
Wm. J. Welsh
Jack Clayton
Hellie Grant
Grace Williams
Tom Chatterton
Marguerite Gibson
Jack Hutchinson
Jasper Smythe
Claudia Smythe
Egbert
Rhoda Dunbar
Phillippe De Lacey
C. M. Anderson
Eva Heazlett
Arthur Maude
Nita Valyez
George Beranger
Harry Archer
Emanuel Reicher
Ernst Reicher
Johanna Terwin
Friedrich Kühne
Robert Burns
Peggy O’Dare
Natalie Warfield
Louise Glaum
House Peters
Pat Kelly
Maggie Murphy
Bill Ford
Thomas Roland
Luella Durand
John Lang
George Fields
Jos. McDermott
Jane Waller
Ivis Pemberton
Frank Bird
Bob Turner
Virginia Pearson
EVA NOVAK
WILLIAM FAIRBANKS
CLAIRE McDOWELL
JACK BYRON
MARION HARLAN
DERRY WELFORD
HIMSELF
Marjorie Whitney
Fitzjames Powers
Elmer Poindexter
J. W. Kerrigan
Ethel Phillips
Nobert A. Myles
Wilma Wilkie
George E. Marshall
Buck Connor
THOMAS MEIGHAN
Charles A. Sellon
George O’Brien
Martha Maddox
Bill Gonder
Mike Donlin
Wilmer Paquette
Suzanne Foucharde
Louis La Roque
Madge Carson
Jacques Foucharde
Abner Lee
WALLACE REID
LARRY PEYTON
H. B. CARPENTER
MARJORIE DAW
STEPHEN GREY
JOHN OAKER
SIDNEY DEANE
HUGO B. KOCH
WM. CONKLIN
WALTER LONG
EMILIIUS JORGENSEN
Chas. Cummings
Adelaide Bronti
Ken Maynard
Paul Hurst
J. P. McGowan
Chief Yowlache
Harry Shutan
Tom Day
Hal Salter
NEAL BURNS
George Pierce
Billye Beck
Hope Drown
Luke Cosgrave
G. K. Arthur
Ruby L. Fayette
Harris Gordon
Bess Flowers
Eleanor Lawson
Gladys Eulette
Helen
Harry
Tom
Dick
Gus Thomas
S. J. Bingham
Phillip Durham
Bert Offord
E.P. EVERS
GEO. BERRELL
WM. DOWLAN
GLORIA FONDA
LULE WARRENTON
H. F. CRANE
MARY RUBY
WM. QUINN
Betty Keller
John Hines
C. W. BACHMAN
ROY WATSON
INEZ WALKER
Janet Dawley
Edward Bouldeu
Kathleen Coughlin
GRACE VAUGHAN
Dudley Kent
Mrs. Brinsley
John Hargrove
Mrs. Hargrove
Marie d’Arcy
Anna Laughney
Willard Ashbrook
Harry Van Meter
Dick La Reno
Kirk Connolly
Dinty
Holon Allen
J.Barney Sherry
J. L. Rich
Noah Beory
George C. Dromgold
Ashley Cooper
Charles Wost
Robert Conness
Habel Trunnelle
Eddie Edwards
Gabe Lincoln
Edith Pretty
Fred Krook
Harry Chin
Louise Lovely
Lewis Cody
Hector Dion
Mrs. A. E. Witting
Marie Hazelton
George Hupp
Tommy Burns
EDMUND COBB
Vitaphone Symphony Orchestra
Trixie Friganza
Gertrude Olmsted
Karl Dane
Margaret Campbell
Barbara Shears
Cesare Gravina
Antonio D'Algy
Jack Ames
Mary Bryant
Wendell Martin
Ulysses
Red Dugan
CORINNE GRIFFITH
George Howard
Eulalie Jansen
James O’Neil
Howard Truesdale
Jacob Kingsbury
Darel Goodwin
Martin Faust
Mrs. Ida Ward
Mrs. William Beshtel
EILEEN SEDGWICK
William Sherwood
George Cowl
Justine Cutting
Viva Ogden
Elmer Peterson
H.S. Mack
Harry Rytinge
Beatrice Mabel
Philip Kent
Anita Kent
Henry Ives
Jack Newton
Bert Busby
Alice Forsyth
L. J. Shumway
Manuel Ojeda
Ruby LaFayette
Jim Farley
Mr. McHugh
Dick LaReno
Tom Walsh
Roy Marshall
Billy Sullivan
FRANK KINGSLEY
C. L. Stevenson
Allan Holubar
MONROE SALISBURY
HENRY BARROWS
RAY GALLAGHER
CHARLES WEST
JEAN CALHOUN
MILTON MARKWELL
LOIS LEE
FELICIA HINDEMARSH
Leslie Austen
John L. Shine
Ida Darling
Amelia Summerville
Frank Kingdom
Howard Hall
Mary Navarro
Jerry Brennan
Sydney Dean
Edward Brady
Gertrude Bambrick
Florence Lee
Jack Bronson
Miss Charlotte Burton
Miss Vivian Rich
Miss Louise Lester
Thomas Lingham
Frank Lanning
Rex Roselli
MILTON SILLS
Molly O'Day
Arthur Stone
Burt Bucher
HERBERT RAWLINS
Mlora Bramley
Amber Norman
Sabel Johnson
Eddie Gordon
Jacques Jaccard
Charles Morrison
Joseph Knight
Caroline Cook
Kay Laurell
Robert Kunkel
JIMMY AUBREY
Jack Cooper
Ed Kennedy
Bobbie Duan
Marine Brown
Henry Galaen
Lydia Samonova
Patsy DeForest
Harry Coleman
Nancy Baring
Edward T. Langford
J. Clarence Harvey
Walter D. Greene
Zelma O’Neal
Photos Martini
Franklyn Farnum
William Armstrong
Gonda Durand
Al McKinnon
W. L. Rogers
R. C. Ryles
Yona Landowska
Peggy Morris
Jean Arthur
John W. Johnstone
"Kewpie" Morgan
Eddy Chandler
Silver Harr
Grace Darnond
Tom Bates
RUTH BURRELL
ELIHU BURRELL
FERNANDEZ STOCKER
BILLY HARDY
JERRY SIMPSON
THURSDAY SIMPSON
SHERIFF
Mary Virginia Kirtley
Old Burt E.J. Brady
Benton Robyn Adair
Florence Billings
Betty Hilburn
Montague Love
Effie Shannon
Marcia Harris
ADELE LANE
Eleanor Boardman
Conrad Nagel
Eugenia Ford
Fred Drake
Jimmy Bradbury
Lee Shumway
Ernest Hilliard
Dolores Costello
Sam Baker
George Burrell
Frank Nelson
James Barrows
Vadin Uranoff
Frank Hagney
John Sturgeons
James Harris (Arnold Prisse)
Bruce Larnigan
Tom Larnigan
Roger Maxwell
Ben Travers
J. Brooks Carney
Claire DuBrey
Charles French
Olga Doris Lloyd
Orlando Wainwright
Veronica Lillie
Bob
Kathie Fischer
Afton Miner
Joseph Harr
Alex Shannon
CHESTER BARNETT
BETTY HILBURN
Kathryn Lean
Earl Montgomery
Joseph Rock
Patsy de Forrest
Albert Martin
Royal Douglas
H. A. Barrows
Helen Bray
W. J. Butler
Kate Bruce
Christine Garth
Doris Barnes
Angus Garth
Annette Garth
Churchill
Radio Operator
MARY DACRE
JOHN TREVOR
RONALD TREVOR
GENERAL TREVOR
Wm. Stowell
Ed. Wallock
Margaret Allen
Fay Tincher
Joyce Coad
LARGARET LORRIS
Phillipe Delacy
PAYNORD KEANE
William V. Mont
Paulette Nuval
Walter Wilkinson
Earle McCarthy
Catherine Clare Ward
Ruth Cherrington
George Cheseboro
Fred Saunders
Alice Mills
Billy Butts
Albert Priscoe
Bill Dyer
William Courtwright
Paola DONNETTI
Robert SANTELL0
Duke de RONDOZA
Lee Morgan
Helen Stanton
Mrs. Saba Raleigh
Ivo Dawson
George Bellamy
Dorothy Fane
Philip Newland
R. Heaton Grey
Windham Guise
Jane West
H. Lloyd
Lionel York
William Parry
MISS SAIN
LILLIE CLARK
MR. DELMAR
Olive Fuller Golden
Elizabeth James
Jane Anderson
RUPERT DANZA
Althea Hanway
Prince Boris
King Rudolph
Olga Marie
John P. Hanway
Mrs. Hanway
Bobby Burns
Aileen Lopez
Charles Stine
Walter Spencer
Paul Deroulede
Juliette De Marny
Georges Treville
Anne Mis
Mdme. Jane Brindesau
A.B. Imeson
Ivan Samson
Robert Lang
Mrs. De Grey
JACK JESSUP
Barbara Marshall
Hawk Lepsard
John Gregg
Wm. Malan
Géne Rogers
Roy Laidlaw
Jola Mendez
Thomas Brower
Mabel Horan
Babe London
Virginia Dale
Jess Devorska
Chas. French
Joe Rains
A. Hollingsworth
Ransh Goodwin
Wes. Buckley
Fontaine Lame
Jim Alamo
J. J. Allen
Stanley Fitz
Joe Delacruz
Sam Poho
Helen Rosson
Alan Forest
William Powell
Richard “Skeets” Gallagher
Adolph Lestina
Emory Johnson
Lou Short
Walter I. Percival
Harry Ratenbury
James Wharton James
Estelle Scott
Ann Murdock
Lionel Adams
Richie Ling
Eleanor Seybolt
Edyth Latimer
Charles MacDonald
Anita Rothe
George Abbott
Louise Hamilton
Herbert Dansey
Carew Grant
Alice Calhoun
Trilby Clark
Philip Stanwood
Barry MacBennett
Tunde L. Rice
Terence O'Brien
Sheila O'Toole
Karpoff
Will R. Wailing
Aggie Herrin
Charles Crockett
Robert Humans
Harry Bailey
Sidney D'Albrook
Broderick O'Farrell
Phyllis Tomley
Charles Pino
Chief Big Tree
Matilda Brundage
MARY PICKFORD
Charles Rogers
Carmelita Geraghty
Sunshine Hart
Robert Armstrong
NEELY EDAWARDS
Howard Enstedt
David Butler
Donald MacDonald
James Corrigan
Robert Ramsey
Ada Mae Vaughn
George Rhehms
Mary Dow
Eileen Swdgwick
JOHN T. MURRAY
HARRY WATSON, JR.
Gertrude Ryan
Mr. Palmer
Stella Razeto
Thomas Thompson
Miss Daggert
Charlotte Walker
Margery Daw
Loyla O'Connor
LIONEL BARRYMORE
Dorothy Gwynne
J. H. Goldsworthy
R. A. Bressee
William Cowper
Martin J. Faust
John I. Donough
KENNETH HARLAN
ESTELLE TAYLOR
ARTHUR HULL
EDITH ROBERTS
CARL STOCKDALE
JOHN COSSAR
EVELYN SELBIE
Grace Huntley
Jack Abbott
Bert Law
F.M. GARWOOD
VIVIAN RICH
Jack Richards
Jose Melville
Harry Von Mets
Edith Borells
Scott Beal
King Clark
Arthur Courtleigh
Agnes Childs
Marcella Porsch
John Judd
Wm. Garwood
Billie O'Brien
Vincent DePascale
Royal Byron
Herbert Tracy
Beverly Travers
Emmett King
Ernest Pasque
John Stepling
EDWARD HILTON
Adrienne Kroell
Gloria Gallup
Alma Russell
Stephen Crane
Renee Kelly
Inez McDonnell
Jay Marchant
Jean Perkins
Wm. Crinley
Frank Alexander
Peg O’Neill
Dolly Ohnet
Alyce Mills
Joe Coppa
Ainsa Charland
May Talbot
Allan Forest
Frank McQuarrie
Edith Hines
Cyrus Green
Bradner Phillips
Jobna Ralston
JOHN LOWELL
EVANGELINE RUSSELL
F. Serrano Keating
Col. Joseph Miller
Dan Dix
Madi Blatherwick
Alice Legacheur
Louise de Rigny
Mary Ellis
Lee Ellis
Jerry Ellis
Betty Ellis
Corporal Cotter
Edna Larkin
John Ogle
Jos. Galbraith
Reaves Mason
Jack Mc Closkey
EARTH RITCHIE
PATSY RUTH MILLER
Pauline Garon
Rockliffe Fellowes
Barbara Luddy
Alec Francis
Edward Piel, Jr.
Carrie Clarke Ward
Katherine MacDonal
Jane Elvidge
Francis MacDonald
Josephine Scott
Mae Allison
Philo McCollough
John Kolb
Nancy Kelly
PEGGY MAY
Beatriz Michelena
William Pike
Nina Herbert
Clarence Arper
James Leslie
Irene Outtrim
Myrtle Neuman
Frank Hollins
Minnette Barrett
Andrew Robson
Katherine Augus
Dorothy Dalten
Marguerite Forrest
Marguerite Gale
Henrietta Simpson
Marie Pagano
Mrs. Tansey
George McQuarrie
EDNA MARIAN
Beatrize Dominguez
Chas. Newton
Andy Waldron
Mark Hamilton
Doris Lloyd
Virginia Davis
Mickey Moore
BETTY COMPSON
Rockcliffe Fellowes
William Austin
LAURETTE TAYLOR
Patterson Dial
Lawrence Grant
Charlotta Minneau
Janet Strong
Edward Stone
Thomas Comer
Florence Ob
Ann Ki
DOLores COSTELLO
Shannon Day
Colin Kenny
Charles Mack
Dorothy Seay
BABY PEGGY
Webster Campbell
Charlie Chaplin
EMMY WEHLEN
W. I. Percival
Eugene Acker
Peggy Parr
Isabel O'Madigan
Francesca Ward
Rose Wood
Alice Turner
Stephie Anderson
FRED GROVES
HUGH E. WRIGHT
ALEC THOMPSON
BERTRAM BURLEIGH
ARTHUR CLEAVE
TOMMY MORRIS
LEO CARELLI
LOUISE NOLAN
Mrs. BRAITHWAITE
MARJORIE GAFFNEY
STELLA BRERETON
BETTY CAMERON
LITTLE ZILLAH
MOYNA MACGILL
REGINALD DENNY
LAURA LaPLANTE
George Marks
V. Pascale
Dorothea De Wolff and Violet Eckert
Virginia Valli
Frank Morgan
Ralph Morgan
Charles Stevenson
Julia Hoyt
Lynn Fontanne
Hugh Cameron
Russell Griffin
Clement Beaton
Harry Byttinge
Frank Trenor
Floyd Frances
Kathryn Adams
Lili Leslie
Jack Underhill
DORA TRAYNOR
HOMER FAIRCHILD
Jacqueline Norton
Myrna Loy
S. V. Sweeney
Marthe Mattox
Robert Perry
Joseph B. (Doc) Stone
Lou Harvey
Raymond Owen
JACK McHUGH
Tommy Hicks
Doreen Turner
Rudolph Valentino
Harry Vogelsang
Philip Saunders
Robert Willis
Tom Moffit
Dick Meadows
Robert McGowan
Betty Saunders
Emma Gertes
Doc Jones
James MacDonald
MARY RYAN
HARRY MESTAYER
HAROLD HOWARD
ALBERT TAVERNIER
WILLIAM BOYD
AUGUSTE BURMESTER
DELLA CONNOR
MARGUERITE BOYD
DAN MOYLES
SOLDINE POWEL
Don Luis Baldarama
Selistino Vargas
Jean Acker
P. J. Lockney
J. J. Lande
Ed Brady
Alan Forrest
Daniel Miller
Edna Bunyea
TYRONE POWER
Harry VonMeter
Caroline Cooke
LOUISE LOVELY
CARMEL MYERS
SIDNEY DEAN
Jacob P. Adler
Daniel Makarenko
Flsetta Brice
Lloyd B. Carleton
Peter B. Lang
Charles Wheelock
“Tote” Ducrow
Maud Truax
Harry de More
Stanhope Wheatcolt
Will Bovis
Scotty MacGregor
Catherine Bennett
Mae Laurel
MIA MAY
CHET WITHEY
Nita Cavalier
Shay
J. F. Evers
Dorothy Dalton
James Rennie
Paul McAllister
Florence Fair
Alphonz Ethier
Frederick Lewis
Emmy Wehlen
Jules Raucourt
Herbert Heyes
Virginia Palmer
Gladys Fairbanks
Vit Guard
Carlotta De Felici
Denis Ward
Caroline Rankin
Carol Chandler
JOHN BOWERS
E. Alyn Warren
Grace Goodall
Rhoda Canby
Irving Mason
Mary B. Davis
Eugenie Woodwar
Pauline Dempsey
William Black
Charles Ascott
Taylor Holmes
Henry Otto
Jay Mansfield
W. Brownlow
Henry Blake
Eugene Besserer
Jean Bernoudy
Ed. Sedgwick
Earl Keaton
Laura La Varnie
Alma Rubens
Gaston Glass
Byron Russell
Peter Barbier
Leon Gendron
James Savold
Mrs. Allan Walker
Ray Allen
Nicholas Dunaew
Gypsy Hart
Tommy Morrissy
Frank Tokonaga
Gordo Keeno
Laurette Taylor
Grey Terry
Nigel Barrie
Beth Ivins
D.R.O. Hatswell
Aileen O'Malley
Fred Huntly
Arnold Prisco
William Ruge
Willie Collier, Jr.
Allan Cavan
Frank Dayton
Stanley Lambert
Grace Manning
Miss Nelson
Mr. Saliff
Baby Dortohty DeWolff
p-John Smiley
Vester Pegg
Harry C. DeMore
Richard Strong
Elinor Rossiter
Edwin Rossiter
Tim Taplin
Zoldene
Belle Stoddard Johnstone
Daniel Brewster
Fiske
Billings
Gordon
Dorothy Seastrom
Raymond Griffith
Ann Sheridan
Vivien Oakland
Tom S. Guise
Edgar L. Kennedy
John Stepping
Jay Morley
Riccardo Espino
Wilton Lackaye
Julia Swayne Gordon
Helen Rowland
Mrs Oscar Hammerstein
Carrie Turpin
Steve Packard
Terry Temple
Joe Blenham
Slim Barbee
Bill Royce
Alice White
Marie Dressler
Burr McIntosh
David Mir
Don Alvarado
Nellie Bly Baker
EMMA DUNN
Clara Knott
Sadie Gordon
Winifred Westover
May Wells
George Le Guere
Gwilym Evans
Mary Dibley
Lilian Hall Davis
Jerrold Robertshaw
Tom Reynolds
Robert Laing
Mercy Peters
Harry Holden
Eddie Brown
WILLIAM DUNCAN
WILLIAM POTTER
Dick Liggett
JAMES HOUSTON
ALLANE HOUSTON
Maggie Breyer
Walter Broussard
JOE MURPHY
William Ricciardi
Lucien Prival
Nicki
Miss Arnold
Jack Tutt
Irma Sorter
Miss Field
Bob Evans
Mary Crawford
Tom Chalmers
Ployd France
Frank Burbeck
RALPH LEWIS
Vadim Uranoff
Robert E. Homans
Jenny Dickerson
Marguerite Skirwin
Gordon McKay
Harry Rattenbury
Maria Corda
Gordon Elliott
Constantine Romanoff
Emilio Borgato
Alice Adair
Helen Fairweather
Virginia Thomas
Doc Cra
Hal Cook
Lois Neilson
J. Sahr
Sonia Marinoff
Andrew Hamilton
Olga
Alexis Kalkhoff
MARIE DORO
LOLA MAY
"LITTLE BILLY" JACOBS
PEGGY GEORGE
MRS. LEWIS McCORD
Anna Q.Nilsson
Lewis S. Stone
Cecille Evans
E.H.Calvert
Jack Standing
James Gerry
Marie Sterling
HENRY WARNER
RUTH ORTON
MIDDLETON
CRAIG
Harry Maison
Kitoria Beveridge
Conne Porter
Bob Green
Tom Brown
Nellie Blake
Selly Crute
Kate V. Tonray
J. Webb Dillion
Eloise Clement
Frank Andrews
Frank Norris
Peter Burke
Jack Rollens
Virginia Novak
Edna Ross
Daisy Cameron
Ashley Buck
Thomas Clemons
Antonio Marvelli
Sidney Fairbrother
Edna Flugrath
JOSEPH H. PARKER
GERALD AMES
BERT WYNNE
LAURA COWIE
Barbara LaMarr
Harry Lorraine
Eagle Eye
Millie Davenport
Ina Anson
Jacqueline Laurentine Boggs
Laurence Mannerby
Donald Mannerby
Catherine Mannerby Truesdale
James Sheridan Boggs
Walter McEwen
Rene Rogers
Ful Cooley
Harry Lauder
Buster Keaton
Justine Johnstone
HANS FREDERICKA
WILHELMINA FREDERICKA
PETER GROSSE
LAWRENCE STANLEY
C.W. Ritchie
Raymond Mc Kee
Julius Frankenberg
Joseph Depew
Marie Day
Bertram Marburgh
Wm. F. Haddock
Walter Pidgeon
Clyde Cook
Ann Adams
Oleta Otis
Fred Warren
Morris
Edward
Alice Grey
Edna Purviance
A. Edmundson
Warren Ellsworth
Martin Bellman
Lem Barlow
Tom Coast
Al. McKinnon
VALLI VALLI
Frank De Vernon
Charles Prince
Mrs. Kate Jepson
Robert Stowe Gill
Peggy Hopkins
Ilean Hume
Frederic Summer
Win. Auker
GEORGE LE GUERE
Rebecca Wright
Wm. Clifford
Robert H. Grey
Lillian Mayward
Mrs. Du Vaul
John Harron
June Marlowe
Jimmie Quinn
Claude Howard
Mian Lewis
Bob Reeves
Nancy Deaver
MR. RALPH INCE
John Sutherland
Ray Hackett
Baby Brooks
Fileen Sedgwick
Ed Baker
Anna Hernandez
Gene Pallette
Allen Sears
Lucille Ward
Rhea Mitchell
Bernard Durning
Janet Eastman
Perry Banks
Oscar Mailling
Mr. Clifford
Miss Florence Turner
VICTOR MOORS
JOHN MULL
MADELINE MACDONALD
MARCH FENTON
FRANK MACQUARRIE
RUBY LAFAYETTE
William S. Hart
Herschel Mayall
Patricia Palmer
Ira McFadden
Emile La Croix
Helen Weer
George Bunny
Mrs. Stuart Robson
Mrs. Burmeister
Annie Laurie Spence
HERSELF
Paul Doucet
Dolores Cassin-elli
Marshall Phillips
Estelle Bland
George Ewing
Henry Rattenberry
Florence Stover
Edward Longman
WM. HUTCHISON
James B. Warren
Jack Carlyle
Charles Bennet
Marguerite Livingston
Marian Skinner
Mollie McConnell
Helen Raymond
Edmond Mathe
Florence Simoni
Marcel Levesque
Eugene Ayme
Doris Gray
Jim Courtney
Ethel Hayes
Howard Shaw
Jean Pallette
Vivian Reed
Al. W. Filson
Julia Casey
John Sanderson
Nettie Arliss
Patrick Casey
SYD CHAPLIN
Mathew Betz
Dave Torrance
Ed. Kennedy
Raymond Wells
Will Lloyd
Ah Wing
L. Pattee
Cap Anderson
George Clarke
Rosetta Price
William Rice
William Wirth, Jr.
Mary Dexter
Walt Whitman
Paul Willis
Olive Dale
Sydney Franklin
Ed Cecil
Seymour Zeliff
Eugene Corey
Lorraine Weiler
Christian J. Frank
MYRTLE GONZLAES
FRED CHURCH
RALPH McCOMAS
MARGARET WHISTLER
Edward Coxen
Edward Connolly
Bob Swift
Dot Love
James West
Helen Jackson
Darrel Foss
Carleton King
M. E. Stimson
William E. Parsons
WILL BARLOW
CATHERINE MOORE
Timmy Sheehan
George L. Cox
Rose Evans
Chas. Ogle
Margaret West
Dixie Compton
Pola Negri
Grace Wendel
Paul Winston
Grete Weisenthal
Hugo Flink
Bennie Leonard
Frank Allsworth
Tammany Young
Billy Mitchell
Gladys Feldman
EDITH STOREY
William Brunton
E. A. Turner
F. E. Spooner
George W. Berrell
Kate Toncray
Norman McNeil
George Robinson
John Dillon
John Gough
R. Paul Harvey
Clif Worman
Alador Prince
Clarence Derwent
Fred Tiden
Peggy Sweeney
Virginia Bowker
Maud Emory
Bonnie Barrett
Malcolm Sebastian
Charles Manley
Doc Crane
Ermete Zacconi
Frankie Lee
Anna
"Arizona" Baldwin
Rosa
Charlie Dorety
HALE HAMILTON
Philo Mc Cullough
Ruth Orlamond
Edward J. Connell
Tillie Leslie
Fred H. Warren
Neal Hardin
Oral Humphreys
Dick Mercer
Olive Templeton
Ned Crosby
Steve Martin
Miriam Carlton
Alice May
Harold Stern
Mrs. Jacques Martin
Elsa Fredericks
Robert Payton Gibb
Augustus Balfour
Walter Wilson
Julian Greer
Edward Boring
Paul Giles
Edna Green
Dan Parks
Elise
WM. GARWOOD
Gee. Morrison
Manuel Sampson
Joss Melville
Edith Storey
Frank Fisher Bennett
Louis R. Wolheim
Anthony Byrd
Sunshine Sammy
NEWTON HOUSE
Robt. Warner
Bud Stevens
Kate O’Connor
Grant Carr
John MacDonald
Patrick Hart
Clarissa Selwynn
George Edmunds
Grace Carlyle
Alphonse Martel
Natacha Rambova
Marion Mason
Kathlene Martin
Kathryn Hill
Ray Grith
PAMELA SAYRE
Walter C. Miller
Charles Van Gordon
Mrs. Sue Balfour
Daniel Jarrett
POLA NEGRI
Gene Gowing
Fritzie Ridgeway
Betty Baker
Paddy O'Flynn
Joe Bonner
Miss Cordray
Miss Gleason
STEWART
BU. VINT'ON
JACQUES FACHARD
MANETTE FACHARD
MANTEEKA
JIM GORDON HENRY MCGEE
Stacia Napierkowska
Marie Louise Iribe
Georges Melchior
Jean Angelo
Franceschi
Abd-El-Kader Ben-Al1
John Maddox
Ivis Remberton
Eileen Marston
Jack Turner
Sayfield Thompson
Edward J. Montague
MYRNA LOY
Paul Ellis
Chas.Hill Mailes
Sydney de Grey
ROSWELL FORD
AGNES LEE
NORMAN BLAINE
NATICA BLAINE
Jack Dougherty
Florence Gilbert
Teddy Samson
Lois Bartlett
H. Dudley Hawley
Syn De Conde
Guy Nichols
Clifford Walker
Fred Stone
Vola Vall
Grace Kerr
Jedlick
Carlotta Highsee
Leila Hyams
Augustin Sweeney
Maude Hill
Edgar Nelson
Leon Gordon
Leslie Austin
Lillian Ten Eyck
Arthur Edmund Carewe
Alice Weaver
Leon Barry
LAMAR JOHNSTONE
Wilfred Melton
Ed. Burns
Tom Blake
Edith Kelly
T. J. Commerford
Lillian Logan
Mac Barnes
John Osborne
Frank Harwood
James Wheelock
Tom Jefferson
Patricia Steele
Alys Murrell
Frankie Adams
Charles Cruz
W. Lawson Butt
Sally Randall
Ivan Mosjoukine
Nathalie Kovanko
Chakatouny
Mme. Brindeau
GABRIEL DE GRAVONNE
HENRI DEBAIN
MME. DE YZARDUY
DEFAS
K. KVANINE
PRINCE N. KOUGOUCHEFF
E. GAIDAROFF
CONSTANCE TALMADGE
ARNOLD LUCY
JOHN HALLIDAY
NATALIE TALMADGE
FANNY BOURKE
MRS. NELLIE P. SPAULDING
MARION SITGREAVES
JAMES SPOTTESWOOD
DAVID KIRKLAND
EDWARD KEPLER
Signora Carloni Talli
Signorina De Marzio
Signora Guinchi
Sig. Lupi
Mastripietri
Poggioli
Castellani
Clara Myers
J. Milton Block
Lucill Bauer
Edward McKiernan
Norbert Wicki
Mary Crowe
Leon Kelly
Ed Mo Laughlin
Hazel Dwight
Yale Boss (Andrew J. Clark)
Ivor McFadden
M.O. Penn
Greighton Hale
CONSTANCE BINNEY
Alicia Lee
Gertrude Hillman
Mark Smith
Grace Scudiford
Wm. Riley Hatch
Adolph Millar
Percy Ames and Charles Esdale
Lee Baker
Charlotte Monterey
Harriet Sterling
Richard Harlan
Mrs. Plater
Miss Nathan
Paul Bryan
William Duncan
Adolph Menjou
Floyd Whitlock
Ray Howard
EDITH JOHNSON
Robert La Monte
George A. Bliss
Dan Skeehean
Edith Ritche
Gaylord Lloyd
Estelle Harrison
Josephine Adair
Bobby Gordon
Bubbles Barry
James Bernoudy
Babe Sedgwick
Ernest Truex
Joseph Allen
Carl de Planta
Joseph Burke
H. E. Koser
Herbert Frank
Harry G. Bates
Maude Murray
William Hayes and Hilliard Karr
Billie Ritchic
Denis Ward, Charles McGee, Hal Vandevelt
William Chalfin
Marie La Manna
Lucille Allen
William Bice
Hortense Zarrow
Helen Holbrook
Patricia Holbrook
Reggie Gillispie
Henry Holbrook
Laurence Donovan
Harry Hilliard
Molly McConnell
Blanche Gray
Helen Rickland
FRANCIS X. BUSHNAM
Marguerite Fletcher
Fred Cottle
Joseph Bexis
Al. MacQuarrie
Margaret Mayburn
Juan De La Cruz
MARGARET VAN
GORDON SACKVILLE
GIBSON GOWLAND
Leslie Stuart
Frances Prim
Rupert Franklin
Jack Dels on
Eleanor Dynn
E. H. Calvert
Lillian Hayward
Clarence J. Elmer
Edwin DeWolff
Carrol Halloway
Edwin Tilton
Edward Markell
Raymond Gallagher
Charles K. French
Marguuerite Show
Virginia Kraft
Paul Gilmore
George P. Hernandez
Maurice Cytton
Emma Meffert
BILLY FLETCHER
George Periobat
Jessalyn Van Trump
Geoffrey Kerr
Henry Vibart
George Spelvin
Harry Short
Prince Rokneddine
Olive Thomas
Stephen Ferrier
Rev. John Ferrier
Edward O'Neill
J. W. Harden
Frank Stanmore
Barbara Everest
Janet Ross
NELL DELANEY
KARL KREIDT
Fred W. Huntly
AUGUST KRAUSE
PATRICK MULDOON
Olga Pietroff
Adolph Meyerburg
Harry Lipman
Nita Martan (Nina Romano)
Nance O'Neil
Ethel Tully
Victor Sutherland
Irving Dillon
Violet Axzell
Rosemary Carr
Madame SCHMITT - HERVE
M. HENRI ROUSSELL
Mlle. EVE FRANCIS
M. DHURTAL
M. MOURUX
Kathryne Wilson
ANDREW FORBES
HELEN CASTLE
Harley P. Hennage
PERCY PUTNAM
H. A. Livingston
Fred. Montague
Nigel Debrullier
Giovanni Martinelli
Edith Lonsdale
Philippe De Lacy
Eva Gordon
Gwendolyn Miles
ASA WHIPPLE
RUFUS COUCH
LUKE ANDREWS
JOHN ORR
PAT MOORE
Chas. Inslee
Sammy Burns
Dolly Dimples
Stephen Carr
Jane Lee
Mrs. Lee
CONRAD VEIDT
BARBARA BEDFORD
IAN KEITH
ARTHUR EDMUND CAREW
CORLISS PALMER
EDWARD REINACH
Frankie Raymond
Bert Weston
CHARLEY CHEDDAR
MY ALLISON
Nigel De Bruillier
Fred Goodwins
Davy Glidden
Flora Edwards
Capt. Jerico Norton
John Edwards
Mrs. Glidden
Tom Brand
Frank Schmale
Bender
Randall Lee
PHIL DUNHAM
Louise Garver
Ezra William V. Mong
Laura Nellie Allen
Charles Charles Borien
Joe Harry Holden
Jim Lou Short
Tim Owens
Suzanne Grandais
Harry Loreine
Efram Zimbalist
Harold Bauer
Martin Ellis
Eva Warren
Paddy Sullivan
Frederic Starr
Rex DeRoselli
Virginia Craft
Chai Hong
Madge Hunt
James Cole
Gary Cooper
Ernie S. Adams
Neil Burns
Lya de Putti
William Collier Jr.
Adrienne d’Ambricourt
Leo Feodoroff
Rosa Rosanova
Claude Brooke
Georges Carpentier
Faire Binney
Robert Barrat
P.C. Hartigan
Cecil Owen
Chas. Oro Nosey Nichols
Reggie Morley
Jos. Gonyea
Mayo Fisher
GLADYS HANSON
Walter Hitchcock
Edith Ritchie
Ruth Bryan
Peggy O'Dare
Florence Noar
Ed Sedgwick
LEW FIELDS
DORIS KENYON
Viola Trent
Harry Fraser
Edw. O’Connor
John Powers
Auguste Burmester
Denis Adams
Charles Paddock
Patricia Mansfield
Harriet Porter
Knute Knudson
Graham Stearns
Beth Johnson
Rex de Roselli
Neal Harris
Dorothy DeWolff
Joseph Smiley
Shirley Palmer
Melvin McDowell
Frank Hagnoy
ROBYN ADAIR
VIRGINIA KIRTLEY
E. J. BRADY
LEO PIERSON
Constance Benne:t
Marie Burke
Matilda Meteyier
Alvin Berkman
Jean Durrell
Frances Durant
James Harrison
Mme. Meïea Radzina
Fred de Silva
Albert Prisco
George E. Romain
Christine Montt
Naricy Zarn
Louis Morrison
Al Jennings
Master Walter Wilkinson
Andrew Johnson
Robert Spencer
Van Kirby
Eva Lewis
Dana Ong
Samuel Curtis
Evelyn Page
Adda Gleason
Bird Hopkins
Madame Olga Petrova
Mrs. Walton
J. Herbert Frank
Thomas Holding
William Carlton
E. J. Radcliffe
Elmo Gray
Jim Gray
Prof. Robert Wade
Helen Wade
Briggs
Stella Dean
Batt Hogan
Con Dawson
Jim Blackwell
George Billings
Mr. A. Blutecher
Mrs. E. Aggerholm
Mr. S. Rindom
ALICE LAKE
Carl Gerard
William Orlamond
"Blue Streak" Billings
Betty West
"Chuck"
Henry West
Harry Bytinge
James Farrell
Edward Coxe
Carmen Sobranes
GABY DESLYS
M. Signoret
Harry Pilcer
TOM MEICIAN
JANE NOVAK
EDMOND BROWN
CARL VON SCHILLER
JAMES LEMINGTON
MISS M. WARNER
EDWIN WALLOCK
Jack Miller
Henry Barrowes
JACK DAUGHERTY
Miriam Cooper
Miss Dupont
RICHARD NEILL
JESSIE McALLISTER
CHARLES OGLE
MRS. WALLACE ERSKINE
JAMES GORDON
LAURA SAWYER
Viola Morton
Eleanor Roberts
Gloria Fonda
Yale Bannet
Mabel Trunnell
Wm. Carlock
Mary Denby
Ernest Joy
LEO MALONEY
Les Bates
Noah Hendricks
Barney Fuhry
HOBART HEILEY
EMORY JOHNSON
MARGARITA FISHER
GEORGE PERIOLAT
LILLIAN LANGDON
BULL MONTANA
Virginia Hammond
EDDIE KING
HELEN HOWARD
MARY WARREN
JAMES GRAY
JOHN WINTERS
Gus Reed
Marie La Hanna
William S. Carlton
George Schrode
George Hanlon, Jr.
Betty Bronson
Dorothy Cumming
Ivan Simpson
Juliet Brenon
Marilyn McLain
Pattie Coakley
Mary Christian
Edna Hagen
William Sheerer
Marcella Daly
Cullen Landis
JANE GREY
WM. J. KELLY
NIGEL BARRIE
WANDA WILEY
James Cavold
Joe Mack
Peter Marchmont
Jewel Marchmont
James Dawson
Ruth Marsh
Johnnie Arthur
Richard Wayne
Sylvia Breamer
Donald Bayne
Steve Nolan
Vida Burns
Rose Nolan
Snaky Burns
Sydell Dowling
Luella L’Estrange
LUCIEN LITTLEFIELD
HELEN MARLBOROUGH
FLORENCE SMITH
Mrs. Thomas W. Whiffen
Guy Coombs
Fraunie Fraunholz
Louis Sealy
Frederick Heck
Wallace Scott
Ann Q. Nilsson
William A. Morse
Jack Burns
Ruth Hennessy
LEON M. LION
MISS LILIAN BRAITHWAITE
MILTON ROSMER
SYBIL ARUNDALE
DORA DE WINTON
REGINALD BACH
SAM LIVESEY
ALEXANDER SARNER
BILL BUTTERS
PEGGY
DICK VAN COURTLAND
FRANCES RAYMOND
CLARK FARRELL
CLARA RAMEREZ
VERNON STEELE
WYNDHAM STANDING
PAULINE GARON
RAYMOND McKEE
JOSEF SWICKARD
PHILO McCULLOUGH
Pete Lawson
JAY MORLEY
William A. Carroll
Jules Hanft
John Hack
Howard Missmer
George Clark
Richard Wengemann
Lillian Hamilton
Robert Byrem
Edith Hannah
Henry P. Koser
DAVID HAWTHORNE
GLADYS JENNINGS
SIR SIMEON STUART
WALLACE BOSCO
ALEC HUNTER
EVA LLEWELLYN
S. MCCARTHY
TOM MORRIS
ROY KELLINO
MASTER ARTHUR BROWN, MASTER PHILIP MANN, MAX NEWBOLD
Mimie Humphrey
Francis Joyher
Alice Mann
Mary Roland
Chas. Griffith
SHERLOCK HOLMES---Willie Norwood
DR. WATSON---Hubert Willis
GRANT MUNRO---Clifford Heatherley
EFFIE MUNRO---Norma Whalley
THE NEGRESS---L. Allen
THE CHILD---Master Robey
Mart Kenyon
Jefferson Landton
Vilma Vaudri
Rogers
Miss S. DeShon
Miss Edna Payne
Alec P. Francis
John Boles
Maurice Murphy
Marion Douglas
John Westwood
JOHNNY HINES
Owen Moore
Kamiyama Sojin
Rose Langdon
John George
Earl Metcalf
Phillip Smalley
George Beban
Charles E. Elder
Gene Cameron
Louise Calmenti
Arthur Thiasso
Dorothy Giraci
M. Solomon
George Barnum
Heden Lynch
Dick Wayne
George Dromgold
Geo. B. Williams
Sidney Deane
Jeff. Osborne
Edna Mae Wilson
Jane Elliott
Ethel Ritchie
Lew Short
Doc. Bytell
Marie Pavis
C.M. Williams
ELSIE WINTERS
W. ATKINSON
Lawrence D'Orsay
Frederick Burton
Edna Phillips
Rose Mayo
Frances Conrad
James F. Fulton
Bud Keaton
John Shirley
Frank Tokanaga
Jos. Girard
Eugene O’Brien
Mildred Havens
BEN WILSON
KINGSLEY BENEDICT
DUKE WORNE
HARRY ARCHER
NIGEL DE BRULLIER
Muriel McCormac
W. Harris
Harold Austin
Alec McLeod
Andrew Thomas Francis Joseph Mulligan
LeRcy
Joseph Barrell
Jack Patterson
Daniel Brennon
Phyllis Brennon
Bertie Raiston
Jode McWilliams
Peg Owens
Pa Owens
Stumpy
Two Horn
Ernest Gledhill
Eleanor Ramsdell
Mark Elliston
DOROTHY CLARK
FRANKLYN FARNUM
WM. CANFIELD
WADSWORTH HARRIS
Jack Tornick
Julia Boumeester
Herbert Hopkirk
Harold Peat
Miriam Fouche
William T. Sorelle
Mary Miles Minter
Mr. Beresse
Wm. Cowper
Alberta MacPherson
Mr. Cowles
JOSEPH NORBURY
AGNES EMERSON
FRANK ELLIOT
WALTER BELASCO
FRANK LANNING
BUSTER EMMONS
Roscoe Arbuckle
Roscoe Karns
Annen Connor
Elise Maison
Norma Nichols
Bert Grasby
LYL LIAN BROWN LEIGHTON
Carlo tta Peel
Emilie Diaz
Frank Ispenlove
Constance Peel
Mary Ispenlove
Raymond Brathwayt
Forest Stanley
Frank Allworth
A. P. Jackson
Clinton Preston
Millicent Evans
Lois Meredith
Jack Hopkins
Harold Hartsell
Wm. Cavanaugh
Mme. Landuska
Grace Leigh
Marjorie Bonner
John Wade
Alaine de l'Estoile
Erneste des Tressailles
Leontine
Montaloup
Marc-Arron
Jean Lasque
Prosper
WM. GARTWOOD
Elle McKenzie
Miss Beresford
MARGUERITE DE LA MOTTE
John Miljen
Billy (Red) Jones
Leon Holmes
Norman Fowler
Vera Hamilton
Frank Foreman
Billy Human
Pat Rooney
Jean Hershott
H. L. HOLLAND
Elmer Morrow
Wm. Quinley
Jesse Arnold
J. F. Conolly
Edmund Breese
John Mahon
WILLIAM MACHIN
WILLIAM GILLESPIE
Chas. Lynn
Rap Ripley
CATHERINE CHISHOLM CUSHING
WALLACE LUPINO
Peter Rankin
Mary Lacey
Joe Nash
Rankin, Jr.
Jim Lacey
Frances Lee
Amos Rinker
Opal Jones
Joe Harding
Ira Harding
Sard Jones
Abbie Harding
John Philip Kolb
William McDonald
Marie de Wolfe
Jennie Dickerson
Mrs. Lewis McCord
Anita King
Harry De Roy
Jack Martin
Frank Montgomery
Franklyn Hanna
Buddy Messinger
Sidney Mason
The Buzzard
The Dove
Kenneth Maxwell
Reginald Clonbarry
Jimby Lewis
Billy Crane
William Brady
Knowles (the butler)
Florence Hope and Gertrude Doyle
Mrs. Wensley Thompson
Helen Marsley
Charles Shelby
Frank Chevy
Joseph Marba
Corinne Adams
Anna Page
James Marsley
Lawrence White
William Colvin
Hedda Nova
Marion MacDonald
GRACE MEADOWS
MATRON
EVELYN YORK
MRS. YORK
TOM HUNTER
Margaret Joslyn
Elsie Greeson
Al Forbes
Mert Sterling
Babe Emerson
Mr. Smith
Mayme Kelso
Ellsworth Gage
Robert Townsend
Jack Charleton
John Murray
Alice Murray
Hickman Bruce
Bud Dorgan
Betty Ellen Estabrook
Bill Bailey
Thomas Estabrook
John Maynard
Norman Maynard
Bessie Neldon
Edward Neldon
Gustave
Rose Davis
Adele George
Snub" Pollard
Harvey Braban
Hugh Buckler
VIRGINIA VALLI
Steven Carr
Brooks Mc Closkey
Lou Gorey
Henry Rich
Gladys Rich
Jack Hold
Alexandra Vancy
Charles de Roche
Robert Agnes
LOUISE GLAUM
Terence Unger
Francis Duane
Tommie Dale
Kathleen Dexter
John Grannan
Terry Dexter
George Stewart
Miss Vivian Reed
Mr. Will Machin
Mr. Chas. Le Moyne
Mr. Al W. Filson
Mr. Lafayette McKee
Captain Ricardo
Miss Gertrude Oakman
Mr. Frank Clark
Dorothy
Lilie Lesl
Alan Quinn
Joseph W. Smith
William Coh
Lupino Lane
Wallace Lupino
Gwendolyn Lee
Henry Gsell
Cordy Millowitsch
Walter Janssen
Bernhard Goetzke
Dagney Servaes
Alexandra Sorina
Fritz Kortner
Siegfried Behrisch
Ralph McCullough
Janice Wilson
Maud Emery
Heinrich Hippo
Alice McChesney
ROSE ALLISON
FRANKLYN HALL
J. O'BRIEN
Fred Thomson
Marion Ridgeway
Robert Gordon
Mary Cornwallis
Danny Hoy
W. H. Davis
Clint Sifton
Master John Huff
Harry Watson
Olin Howland
ROY ATWELL
Winifred Bryson
Lawrence Steers
Jay Hunt
George MacDonald
Mary Charleston
James Mack
Al Hart
Vondell Darr
Lyllian Brown Leighton
Helen Castle
Gleo Madison
Eileen Eedwrick
cb Reeves
Lumsden Hare
Grace Barton
Robert F. Hill
Frank Otto
Mortimer Morrison
Frederick Harrington
Herbert Abbs
Lynn Thomas
May Pavis
Frank Pangborn
Louise Carver
Melbourne MacDowell
GILLIAN LOGAN
JUDD GREEN
Florence Lawrence
Sydney Bracey
Harry Millarde
Wallace Clarke
Sonia Marcel
Fred Marix
Jack Mulhall, Gus Pixley
D. Morris
D. Henderson, Madge Kirby
Katherine Lee
Mrs. La Varnie
Benjamin F. Wilson
MIS. William Bechtel
Doris Hill
Kewpie Morgan
Arthur Clayton
Adelaide Wood
Hazel Henderson
JAMES CLARENCE
Clifford Bruce
Gertrude Coghlan
Olive Drake
Bessie Byton
Kathleen Humphrey
Mlle. ANNA PAVLOVA
RUPERT JULIAN
EDNA MAISON
WM. WOLBERT
JOHN HOLT
HART HOXIE
LAURA OAKLEY
Ora Devereaux
Miss Florence Reed
Miss Blanche Davenport
Mr. Robert H. Barrat
Mr. Fraunie Fraumholz
Mr. William A. Morse
Mr. John Karney
Mr. James O'Neill
MARION WEEKS
ROBERT BROWER
HARRY BEAUMONT
EDWARD O’CONNOR
FLORENCE DAGMAR
MASTER JEROLD WARD
WALLACE PIKE
Curtis Cooksey
Lila Chester
Alexandria Carewe
Grant Darcy
Irma Darcy
U.K. Houtp
Katherine Amos
Ida Easthope
Jeannie MacPherson
Jim Radburn
Kate Vernon
Robert Travers
Joe Vernon
Emily Radburn
Sam Fowler
Colonel Bollinger
Mrs. Vernon
Wm. Carrol
Bebé Daniels
Armand Cortes
DORIS MAY
JOHN WAYNE
ELIZABETH WAYNE
FRANK WAYNE
HERBERT KNOX
NAN MOSBY
Marjorie Allison
Marion Mack
Harry Cornelli
John Geough
Rosemary Cooper
Arthur Standish
Elizabeth Edwards
Squire Blair
Doctor Edwards
Louda Blair
Harry O'Connor
Al Kaufman
J. A. Murphy
Orrin Austin
Fay Lempert
Marshall A. Neilan
Raye Hampton
Lafayette McKee
Newton Campbell
Slim Padgett
Alma Deer
Pietro Sosso
JOSIE SEDGWICK
Teddy Gerard
Divvy Bates
Charles Meredith
Eleanor Harock
Lillian Tucker
Frank Coleman
Jake Abraham
Florine Hanna
Herman Ilmer
Norbert A. Myles
William Crinley
Glenn Hunter
Zasu Pitts
Louis Mortelle
Robert McKenzie
Helen Willoughby
Sid Powell
La Carmona
Nan
Nigel deBruiler
Bridgetta Clark
Virginia Southern
Isabel Keith
Kathleen Chambers
Cora Macey
Carrie Daumery
Thur Fairfax
Achilles Payne
Sallie Sloppus
Colletta Powers
LaFayette F. McKee
Tommy Sheehan
Julius Frankenburg
Fielding Powell
Dr. D. Melfi
Marie
Belle de Farge
Bob Benton
Betty Frazier
Joe Malone
GILDA GRAY
Harry Morey
Mme. Burani
Gaylord Jones
William Evans
Guy D'Arcy
Lamar Johnstone
Bob McKenzie
Chester Ryckman
Novak
Harry Larraine
Catherine Young
Norma Shearer
William Buckley
Jimmy Adams
Charlotte Pierce
Frank McIntyre
Beth Elliott
Franklin Royce
Martin Drury
Harry Blakemore
James O'Neill, Jr.
LOTS WILSON
Hazel Keener
Myrta Bonillas
A. Voorhees Nood
Sara Alexander
Mr. Bushman
Miss Bayne
Marc Mac Dermott
Enid Barwell
Margaret Greene
Buffalo Bill, Jr.
Lorna Palmer
Edna Hall
J. P. Lockney
D’Arcy Corrigan
N. E. Hendrix
Harry Belmore
Clyde McClary
William Ryno
Master Cy Belmore
Sammy Thomas
W. Y. Ryno
J. Farrell McDonald
Beatrice Burnham
Blanche Rose
Marjorie Prevost
Bob Blake
Robert Dudley
Mildred Marsh
MARGARET CHRISTY
John Harding
George Wallace
Virginia Lambert
Mrs. Christy
Mrs. McAllister
Grace Dalton
Sunshine Sambo
Josef (Ed Coxen)
Peter Clark
Jean Durell
Elmo Billings
BEN TURPIN
SLIM SUMMERVILLE
Kathryn McGuire
C. C. Miller
Blanche Light
Ella Herman
Baby Helen
Carl Snyder
Grant Pearson
Mme. Bourgeois
Lois Lamay
Viara Horton
FRED THOMSON
HELEN FOSTER
HARRY WOODS
MARY LOUISE MILLER
CLARENCE GELDER
DAVID (RED) KIRBY
C.W. MACK
E. Van Beaver
Wilfred Taylor
Mr. FRED PAUL
Mr. FRED MORGAN
Miss BLANCHE FORSYTHE
Douglas Mac Lean
Molly Hawkins
Jack
Burt
John Hawkins
George Felix
Frank Staple
Frank Staples
George Odell
Viola Lind
H. B. Warner
Ali Zaman
CHARLES DISNEY
ANITA KING
CONSTANCE JOHNSON
Neil Hamilton
George Rigas
Ruth Dwyer
Steve Murphy
John Buroh
Herself
Silver
Bruce Cameron
Ben Cameron
Richard Warner
Mary Rodger
Jack Connors
Priscilla Pringle
Dolliver Dippie
Mary Kelly
John Livingston
Paul
Trixie
Hank
Cecile Adams
Laëlla Carr
William Reuscher
William Marks
Chas. W. Mack
Newton House
Georgette Bancroft
Ramon Novarro
Claire MacDowell
Roy Jones
Bill Barton
Grace Melville
George Gyton
Marin Sais
Merrill McCormick
Steve Carrie
Faith Hope
Joe Girad
John Sampson
Velman Whitman
Louise Dunlop
Fay Brierly
Leon D. Kent
Don Mc Donald
Chas. Morrison
LEWIS DAYTON
EILEEN PERCY
JOSEPHINE CROWELL
PHILO MCCULLOUGH
LOTTIE WILLIAMS
C.NORMAN HAMMOND
J.AY BELASCO
LON CHANNEY
Orin Jackson
Poodles Hanneford
Mabel Frenyear
Leslie Stowe
William Dunn
Lila Blow
Rolinda Bainbridge
Elsie Mac Leod
J. B. Hollis
Armorel Mc Dowell
Walter Walker
Homer Hunt
Albert Parker
Ada Gilman
Frank Lalor
Betty Tyrel
Spike Robinson
Donna Drew
Rubye De Remer
Tom Powers
Florence Deshon
Florence Johns
Margaret Nevada
BILLIE REEV
Dick Ross
Lillian Clay
Arthur Lyons
Addie McPhail
Frances Kirkland
Jack Billings
Harry de Roy
William De Vaul
LEON ERROL
DOROTHY GISH
NITA NALDI
GEORGE MARION
FRANK LAWLER
EDNA MURPHY
JAMES RENNIE
WALTER LAW
REGINALD BARLOW
Thomas Braidon
Octavia Broske
Maybeth Carr
Katherine Stewart
Paul Kelly
Fontine LaRue
Kate V. Toncray
Professor Robert Wade
MONTE COLLINS
ROY L. MCCARDELL
J. Gordon Cooper
FRANK ARMSTRONG
DORA DRUCE
DENTON DRUCE
MRS. DRUCE
MARCIA LAMAR
THE MONEY SPIDER
Pietro
Joe Martin
Tom Meredith
Laura LaPlante
Thomas Chatterton
Elsa Lorimer
Edward Tilton
Eddie Dennis
THEDA BARA
Roscoe "Fatty" Arbuckle
Little Mary McAlister
Granville Bates
William F. Clifton
Chris Pino
Manuel Cane're'
Ollie Kirby
Arthur Millett
J. L. Powell
Jean Goulven
Annette Perry
Danny Morgan
G. Raymond N. Beau
Verna Merser
DOROTHY WOLBERT
Ann Kirk
Matthew von Betz
Marcel Murphy
Ralph Benson
Bellamy Benson
Nora Murphy
Tim Flanagan
Miss Kemp
Annie
Fannie
Cyril Gordon
Florence Barry
John Barry
James Farley
Vera Voronina
Robert Edeson, Russell Griffin, Carleton Brickert, William Riley Hatch
Isabel Rea
Thornton Cole
Selden Powell
Helen Hart
Frances Sansom
Ferdinand O'Beck
Jessie Terry
Joseph Herbert
Louise De Rigney
Jack Drumer
Charles Duncan
Mildred Cheshire
Duane Thompson
Felix Valle
ESTER WOOD
F. ROBINSON
CHARLES DUDLEY
MRS. JOE MARTIN
George Bailey
James O'Neil
A.H. Van Buren
Dorothy Bernard
Maurice Stewart
Roland Reed
Jean Emar
Vivien Rich
VERA LEWIS
Newton Hall
Gertrude Messinger
Joe McGray and G. E. Jackson
Mary Philbin
Garreth Hughes
"Cameo"
Ray McKee
Jim Torbell
Alice Gordon
Ed. Favor
Ethel Daniels
Rose Blossom
John Haskins
Mary Haskins
George Haskins
Clara Byers
Harry Spingler
Whiskers Ray
Harry De More
Nellie Grant (Mathilde Baring)
Mrs. Dan Russell
Vera Stedman
Kate Muggleduffie
Herman Upright
Lorraine Eason
Peewee Short
Arthur Justin
Shirley
Jos. W. Girard
Willard Wayne
Hayford Hobbs
Minna Grey
Dolly Holmes Gore
Sydney Vautier
Jim Kelly
James Herts
Edna Gregory
Zip Monberg
Bill Corbitt
Chub Barnes
Walter Maly
Jack Barnell
etc.
Josie Melville
Edward Everett Horton
Z. Wall Covington
Anne Schaefer
Erwin Connelly
Leonore Von Ottinger
Margaret McRae
KATHERINE SELWYN
GEORGE WINTHROP
ALAN THURSTON
MRS. VAN THORNTON
May Geraci
J. Demsey Tabler
Alberta Lee
Buddy Rossoner
Mabel Taliaferro
Harry L. Coleman
Leila Frost
Kate Davenport
Alfred Kappeler
Malcolm Bredley
ALAN FORREST
NORAH CAVANAGH
LYDIA KNOTT
CHAS. SPERE
GENEVIEVE HARBISON
HARRY HOLDEN
Tom Henderson
Edna Williams
Julia Jackson
Marie van Tassel
Leon De La Mothe
Truman Van Dyke
Charles Wells
Edgar Allen
Andrew Waldron
Paul Clemons
Lucille Clemons
Ned Hastings
LILLIAN FORD
JANET FORD
William H. Tooker
Mrs. Lillian Paige
Eldean Stewart
Ed Benson
Dorothy Raynor
Jack Lipson
Larry Semon
Chas. Meakin
Jane Hathaway
Lewis Short
Edna Mayo
Benton Clune
Margaret Watts
James J. Jeffries
KATHERINE MACDONALD
Spottiswood Aitken
Ada Gleason
Doc Cannon
Jim Gordon
Mrs. L. C. Harris
Robert Laidlaw
Master Breezy Reeves, Jr.
Lillian Lorraine
Henry King
William Lampe
Fred Whitman
Daniel Gilfether
Baby Osborne
R. D. Armstrong
Mildred Reardon
Martha Petelle
William G. Nally
Earle Foxe
Chas. Wheelock
Yakima Canutt
Bob Walker
Bill Donovan
Archie Ricks
Wm. Hackett
Anita Garvin
Richard Newton
Elliott Cook
Steve Aldrich
Hepzibah Perkins
Gustaw Schmidt
Nate Muggleduffie
Helen Howe
Grace Temple
Ralph Goodwin
Frank Bartlett
Benjamin Goodwin
Nita O'Neil
CHARLEY WEST
LESTER CUNEO
Langhorne Burton
Lulu Warrenton
Matt Dalton
George Leighton
Rose Dalton
Annette Gilbert
Gertruse Aster
Mona Liza
Nellie Parker Spaulding
William Marshall
Peter Stearns
Matthew L. Betts
C.d e Vidal Hundt
Jack Sterling
Bertha Gerson
Samuel Weintraub
Samuel Lowett
Jack Singleton
Babe Otto
Daddy Manley
Mother Benson
Pearl Cunningham
Grace Harrissay
William Casey
Mrs. Wallace Brakine
Gladys Gano
Edith Wright
Vulcan
Sara Mason
Dolly Larkin
Ida Drew
Besse M. Wharton
Fred J. Butler
Pat Hartigan
Charles Briden
Philip Hahn
Auguste Burmeister
WM. S. HART
Dorothy Revier
Louis Payne
Will Walling
C. H. Wilson
Tote Ducrow
Edmund Cobb
Florence Dixon
John Hopkins
Clairette Anthony
Tote De Crow
Frances Terry
Miss Gerber
Clara Miller
Joseph Manning
JULIO SANDOVAL
MARIE LOUISE
MRS. COLLEEN MOORE
A. L. SEARS
W. H. BAINBRIDGE
A. TAVARES
GEO. FRANKLIN
DUKE LEE
Fritzi Ridgeway
Carroll C. James
Ulibrich Haupt
Beth Bassett
Lettie Ford
William Courtleigh, Jr.
Jeanette Rutland
Charlie Ogle
AL. ALT
Juanita Fletcher
Harry MacDonough
RayMcKee
Red Hepner
Toby
Joanne Morgan
Clem Windloss
Ethel Gray Terry
Claire Martin
Robert Whitworth
Kenneth Hunter
Frazier Coulter
William Shay
Laura Hope Crews
George Gebhardt
Jane Wolf
Florence Dagmar
Evelyn Desmond
Edward Harley
Frederick Wilson
WAUNDA WILEY
Fitz Hall
Sigrid Holmquist
Edward Phillips
Fred C. Thomson
Mme. Rose Rosonova
William Nally
CHARLES DORETY
HARRY KEATING
CONNIE HENLEY
FELIX ST. PIERRE
MILDRED
ARNOLD LAMBERT
ANNE ST. PIERRE
BRIAN GODFREY
DAVID CADWALLADDER
Marie Mosquinia
Dan Russel
Miss Peggy Pearce
Buck Higgins
May West
BILLIE RITCHIE
LOUISE ORTH
REGGIE MORRIS
Mary Louise
Harold Skinner
Ella Gilbert
Donald Watson
Madeline Eastin
Roscoe “Fatty” Arbuckle
Buster" Keaton
Ann Little
Otto Brower
Nate Miggleduffie
Ann Brody
Mary Foy
Henry Kolker
Don Bailey
Ah Tov
W. S. Rice
Ivor McFadde.
Pex DeRoselli
William Cokill
Jack Gardner
Cynthia Stanton
George Ryder
Oliver Kent
Perry DeLong
Mrs Stanton
Ellen Cassidy
Malcolm Sabiston
Lorraine Rivero
Hy Mayer
Billie Armstrong
JACK MOWER
ELEANOR FIELD
Raymond Whitaker
Marie Hazleton
Dick Ryan
Geo. French
Emil Lieban
Ann May
Walter Perkins
Vincent C. Hamilton
Jesse Herring
Melba Lorraine
Joe Daniels
Marsh Strong
Nelson Scott
Hiriam Nesbitt
Mrs. William Bechtal
Maro MacDermott
T. Tannenote
Hilliard Karr
Delores Brinkman
Catherine Jellks
Stephen Barnard
Casson Ferguson
Thomas MacEvoy
Yale Benner (John Walker)
Edna Johnston
Dorothy MacKaill
Jerome Trevor
Helene Montrose
Jean Bronte
Ed “Hoot” Gibson
RUTH McALLISTER
John Gilbert
William Anker
Doris May
Fred Gambold
Frank Kingsley
Gertude Short
Eugenia Tuttle
Ed Brady and James Farley
George Siegman
O Hana Yamada
Saul Harrison (Joseph Bingham)
Grace Haverty
Jack Williams
Anne Leigh
Walt Lentz
LORRAINE EASON
DICK SUTHERLAND
CHARLES HILL MAILES
STANTON HECK
JACK HILL
DAVE MORRIS
A. CHERON
Baby Richard Headrick
Carol Holloway
B. T. Henderson
THOMAS BATES
Rex de Boselli
VIRGINIA DIXON
Charlotte Jackson
Louie Ducey
Claire Claire
Will Rogers
Clarence Oliver
Anna Lehr
Robert Conville
Hugh E. Thompson
El Ernest Garelo
William Seiter
Al. Green
Charles E. Anderson
Wilfrid North
William Marion
Lila Leslie
Laurence Steers
Helen Walron
John Lince
Lalo Encinas
Big Tree
Lael Trunnelle
Wayne Barrow
Philip Carew
Joseph Byron Totten
o. Hayakawa
"Shorty" Callahan
Wm. Vaughn
Hart Hoxie
Jack Pyles
Willard Louis
Chas. "Heinie" Conklin
Max Davidson
The Texas Kid
Celeste Janvier
Charles Belcher
Mme. Mathilde Comont
Mme. de Bodamere
Phillipe De Lacey
Walt Kendall
Edgar Douglas
Maris Pavis
EDWARD ABELES
Betty Shade
Jane Darwell
Monroe Salisbury
SUCCO HAYAKAWA
Bartine Burkett
Hrland Tucker
JAMES KIRKWOOD
GRACE DARMOND
CARMELITA GERAGHTY
Henry Biddle
William Tripple
Maxfield Stanley
Geo. McDaniel
Wm. Hakeem
MR. McCULLOUGH
GUY SILVER
Carl Varden
Mary Quinby
Buddie McQuoid
Joe Rock
Irene Warfield
Lillie Fisher
William Fisher
Joe Wallace
Lionel Atwill
Reginald Mason
Ellen Cassity
Joseph Brennan
Eva Sothern
Stella Seager
W. A. Orlamond
Don MacDonald
Sally Long
Ethan Laidlaw
Herbert Stanly
Joe Henaway
Hazel Alden
Madelyn Klare
Elsie Sothern
Alvina Alstadt
William Heidloff
Eldine Stuart
Ann Rork
Dick Folkens
Marion McDonald
Nita Cavalerie
James Llewellyn
Edith Llewellyn
Malcolm Thorne
Leonati
Joy Llewellyn
Stephen Brand
B.W. Hopkins
C.E. VanAuker
A.C. Hilts
JERRY MURPHY
Pete Koft
J. Hamilton Witherspoon
CHAS. MAILES
Marion Coakley
Holmes E. Herbert
Ethel Wright
Baby Bruce Guerin
John Cosser
Clay Clement, Jr.
Douglas Redmond, Jr.
Louis Grizel
Ethel MacFarland
Alan MacFarland
Mary Finnegan
Jimmy Brown
Mrs. Brown
Dr. Hillman
Mrs. Finnegan
Dr. Blake
Harris
Dunn
The Baby
Ginger Smith
Luigi Riccardo
Med Sparks
Beese E. Wharton
Bobby Harmon
Con MacSunday
Alfred Ilma
Eddie Durn
Lefty Lewis
Margie Willis
Mae Dean
Jack Sharky
Charles Moore
Mack Ridgeway
Joe Moore
Re x De Rosselli
Anton Fischer
Bruce Barker
E. Roberts
Bud Jamison
Garrick
Marcia
Bennet
J.H.Gilmore
ANDRES
JOHN FORDYCE
CAROLYN CARTER
Jack Lawton
Louise Granville
Marguerite Skirvin
James Malaidy
Edgar L. Davenport
Myra Brook
Joseph Dowling
Rose D'one
Frances Marion
Arthur Thelasso
Collin Kenny
Emmet King
J. Parks-Jones
Gustav Seyffertitz
John Charles
Frank J. Murdock
ORS GREY
WINIFRED GREEN
Lila Lewis
Francelia Billington
Carter DeHaven
Mrs. Eddy
Lucile King
Harry Crane
Harry Nelson
Aileen Pringle
Antonio D’Algy
Mary Hawes
Katherine Bennett
Lightnin' Ferguson
Jake Levering
Kathleen Emerson
Al Edminston
Gladys Varden
LAFAYETTE McKEE
E. N. Wallock
Ora Carew
T. C. Jack
Jos. Singleton
Mabel Normand
Fritz Brun#ette
Edw. J. Piel
Richard Francis
Aggie Farrington
Tom Cross
Gypsy Sartoris
BOB ANDERSON
ETHEL RITCHIE
JENNIE LEE
J. F. MAC DONALD
CAP. ANDERSON
JACKWOODS
Charles Wellesley
Frances Cappelano
Elsie McCloud
Ina Bourke
J. K. Murray
Robert Vignola
Albert Bolton
Albert
Hugh Bennett
Charles H. West
MARSHAL NEILAN
DOROTHY GREEN
LOYOLA O'CONNOR
MRS. LEWIS MCCORD
EDWARD LEWIS
TEX DRISCOLL
AL ERNEST GARCIA
Ollie Golden
Harry D. Southard
Chester Morris
Bobbie Vernon
Adriana Costamagna
A. De Virgilo
Alberto Nepoti
Livia Martino
Katie O'Doone
Dennis Reilly
Jake Trumbull
Tod Cuyler
Mr. Welkin
Joseph Crowell
Lee Beggs
Hazel Goodwin
Earl Mayne
Phil Sanford
Roy Applegate
Al Reeves
H. Carey
Jim Assof
H. Haddad
Stanley King
Jack Sharkey
MONTGOMERY IRVING
HAMLET McGINNIS
Mr. Linkey
Miss Adair
Mr. Benson
Charles Frohman Everett
Madelyn Clare
Howard I. Smith
Wilson Reynolds
Marlow Bowles
Leona Ball
Florence Barr
Evelyn Ward
Richard Travers
Bill Gettinger
John C. Flinn
RALPH KELLARD
Margaret Green
Daniels
Tim Morgan
Daisy McAlester
James Durbin
Joseph Schildkraut
PORTUGUESE PETE
Helen Millington
CATHERINE HENRY
MARION WARNER
OLIVE THOMAS
WARREN COOK
LOUIS LINDROTH
CHARLES CRAIG
THEO. WESTMAN, JR.
WM. P. CARLTON
KATHERINE JOHNSTON
ARTHUR HOUSEMAN
MARCIA HARRIS
Joseph DeGrasse
William Eagle-Eye
Olga D'Mojean
Beatriz Dominguez
Arthur Jasmine
Wallace McDonald
John Charles Brownell
Andrew Smith
Wm. Irving
FATTY VOSS
Za Zu Pitts
Bobbie Mack
CATHERINE CALVERT
Helen Montrose
Ann Dearing
Claire Whitney
Norah Reed
Albert Hacker
Earl Lockwood
Walter Smith
Robert Minot
Edith Pierce
Allen Simpson
Fred Burton
Thomas F. Blake
Delice Norton
Esther McCormick
W. E. Parsons
William Chaflin
Saul E. Harrison
David L. Don
Joe Opp
Walter Duncan
Edith Thornton
Mrs. DeWolf Hopper
Perry Reynolds
Marjorie Leeds
Dorothy Devore
Camilla Horn
Louis Wolheim
Boris de Fas
Ullrich Haupt
Bess True
George Roydant
Mary Boland
Nicholas Barrable
Attalie Damuron
Bruce Kent
T. J. Comerford
LaFayette S. McKee
Frederick Annerly
Rubye de Remer
Dick Thornton
Ridgley Torrence
Corinne Torrence
Mrs. Jack Stevens
Betty Hutchinson
Rex De Roselle
Ann Dodge
ETHEL WEBER
LOIS WEBER
CHARLES GUNN
Maxine Elliot Hicks
Dagmar Gadowsky
Stanley Goethals
Spottiswoode Aitken
Frank Champeau
Col. T. J. McCoy
Millian Leighton
Maxine Elliott Hicks
Doris Keane
Leonard C. Shumway
Lucy Donohue
Doris Lee
Hal Coolcy
Jack Blossom
Walter Shumway
George Chapman
Henry Ainley
Philip Hewland
Christine Rayner
DILLO LOMBARDI
GIULIO DEL TORRE
LUIGI DUSE
EVANGELINA VITALIANI
TINA AGNOLETTI
ANNA RIPAMONTI
VINCENZO DE CRESCENZO
William Francy
GEORGE HACKATHORNE
MARY CARR
Basil Reska
Freda Hampton
Eric Larne
Lina Cavalieri
Gertrude Robinson
Raymond Bloomer
Leslie Austern
J. Clarence Handysides
Mrs. Matilda Brundage
Corinne Uzzell
Hugh Van Schuyler
ENID BENNETT
Mr. Robert Schyberg
Mrs. Ellen Aggerholm
Mr. Andre
Mr. Krauss
Miss Renée Sylvaire
Miss Grandjean
BOBBY VERNON
Yola D’avril
J. DABNEY BARRON
IRENE HOWLEY
Walter Horton
George A. Wright
John Arden
Jim Foley
JOHN MONTGOMERY
HARRY VON METER
DICK LA RENO
WALTER SPENCER
PERRY BANKS
WM. TEDMARSH
JOSEPHINE HUMPHREYS
NAN CHRISTIE
ALICE ANN ROONEY
MADAME KLUGE
CHAS. WEBB
AL FORDYCE
G. E. RAINey
MRS. WALDERMEYER
ANNA M. MORRISON
MARTY MARTIN
Pomeroy Cannon
Donald Fullen
Andree Tourneur
Mathilde Brundage
Wm. Hayes
Lola Stummt
Josephine West
Aln Forrest
Sydney Deane
Dcon Routh
Ben Hopkins
JIMMY ADAMS
Dolores Gallito
Cavallo
Palomino
Pedro
Claire de Lórez
W. E. Willet
Peter Condon
Edward Brennan
Julius D. Cowles
Cliff Bewes
Dora Rogers
Larry Lyndon
Joey Jacobs
Willow Winters
Katherine Young
Violet XXX Neitz
Miss Norma Gould and Ted Shawn
Frank A. Lyer
TOM BATES
MAY
PAT CHRISMAN
Bliss Daly
Lucy Kent
Mrs. Kent
Bert Daly
Jom Daly
J. Frank Glendon
George Kunkle
Jack Abrams
Mrs. Crampton
Frances Mayon
Adele Woods
Martha Russell
JO DUGGEN
JIM LUCAS
Albert Ray
Maudie Dunham
C. McCarty
Henrietta O’Beck
Miss Audrey Hughes
Miss PEGGY KURTON
Mercedes Diaz
Wm. J. Spencer
Milton Flynn
Marie Beaulieu
Vetal Beaulieu
Norman Aldrich
Dave Roi
Louis Blais
Father Leclair
Harry Lamont
Fred Herzog
DOROTHY REVIER
Howard Trussdell
Peggy ODare
Fred Stanton
William Eagle Eye
Richard Cummings
SAM HARDY
LOUIS JOHN BARTELS
PHILIP STRANGE
BARBARA STANWICK
Rodney Stone
Isobel Thorpe
James Thorpe
Sir Henry Criggins
John Randall
Ed Randall
Olive Hasegourde
WARNER BAXTER
Sharon Lymn
Raoul Paoli
Byron Douglas
Hugh Thomas
Jean Armour
Thomas Butler, Jr.
Thomas Butler, Sr.
Julia Celhoun
Jack De Long
Kate Toneray
Arthur Millette
Mme. A. Lerida
Mr. Maurice Luguet
Mr. Emile Andre
Mr. Numes
Mr. Manson
Mr. G. Severin
Mr. M. A. Dutertre
Adrien Petit
BILLY WINTHROP
SAMUEL WINTHROP
CAESAR FORBES
BEATRICE FORBES
ERNEST PEABODY
PHIL HASTINGS
CYRUS PEABODY
Al. W. Elison
Harry Furniss
Joan Lowell
Warren Cook
Jane Connelly
Kathryn McGurie
Joseph Keaton
Laura Hilton
Percy Pembroke
Chas. Brinley
Valerio Olivio
Phillip Dunham
Billy Rhodes
Melbourne McDowell
Willis Granger
Maude Fealy
Iva Shepard
David Landau
Harry Knowles
Harmon McGregor
Shirley De Me
Maurice Steuart, Jr.
Frederic Sumner
Wm. Summer
Harry Warden
Lucille Page
Perry Arnes
DOROTHY RIDER
STEPHEN RIDER
MRS. RIDER
HUGH MARTIN
Louise Lagrange
Maurice Cannon
Carmen Arscella
James O. Barrow
Mrs. George Hernandez
Adam Ladd
Hannah Randall
Mr. Cobb
Emma Jane Perkins
Jane Sawyer
Mrs. Randall
Miranda Sawyer
Rev. Jonathan Smellie
Minnie Smellie
Mr. Simpson
Mrs. Simpson
Clara Belle Simpson
BABY MARIE OSBORNE
Velma Clay
Frederick Vroom
Mrs. Lucille Ward
Gordon Marr
Chance Ward
Slim Pagett
Elsie Van Name
Alexandra Carlisle
William A. Sheer
Frank Holland
Jane Kent
Harry Bartlett
Minnie Greenwood
Toun Stepping
DORALDINA
William H. Bainbridge
George Chesbro
George Pettie
Bessie Bowden
Will Bowden
Annie Bowden
Geraldine Horton
Charles Horton
John Hargraves
Austin Trull
LOUISE DRESSER
DOUGLAS FAIRBANKS, JR.
Barbara Worth
Henshaw
Andre Cuneo
John Gordon
Jim Bryson
Frank Hilton
Ethel Gordon
William White
Jimmie Marsden
Chick Morrison
Ida Tenbrook
Margaret Whisler
Mr. Gilfeather
Wm. Taylor
Jack Bryce
Dick Johnson
Nell Franzen
Ross Letterman, George Allen, Joe Martin
E. J. Denecke
Buster Emmons
Walter Stephens
Wm.Edler
Frank Erlanger
Jane Pepperell
J.P.Wade
Edw.Jobson
Leah Gibbs
Harl McInroy
Lennox Pyne
Ulick Shreeve
David Fleet
Dr. Tate Waysmith
Milee Boyter
Jugnet
Doris Crayden
Rev. Roger Rayden
Mrs. Crayden
Mabel Brown
Lillian Christy
William Robyns
Harold Fashay
Marie White
Laura Burt
Winifred Leighton
Allan Edwards
May Hopkins
Philip Van Loan
Bertram Marburg
Warren Herrigan
Joyce Carey
Ben Welsh
Fred Sullivan
F. M. Wc.:
Greichen Lederer
Fred Conklin
Dorothy Lewis
Tony Gay
Jim West
Edward Allen
Tony West
Gertrude Berekley
Theresa Maxwell Conover
MILDRED MOORE
EDDIE LYONS
Lewis W. Short
Andrew Robeson
William Dowlan
Elsie Cort
HARRY RATTENBURY
STELLA ADAMS
COMPSON
J.C.Carroll
Mary Mersch
Pete Gerald, Jerry Ash
GOLDA CALDWELL
CHARLES HICKMAN
KONA LANDOWSKA
LOUIS A VALDERNA
Lois White
Violet Eddy
George Cheesebro
Wm. Shea
Frank Crane
Olive Tell
Jane Alderson
Ernest Bickley
Millie
Tessie
Mrs. Heward
Mrs. Bickley
Arnold Cullingworth
Geo. Saunders
Chas. L. Hamilton
Mrs. Hamilton
E.F.Roseman
O.A.C.Lund
Nathilde Baring
Mrs. Edward Earle
Grace Cole
George Warner
Beverend Hanson
Mary Benton
Marcella Pershing
Barry Archer
Walter McCrea
Edith Peters
Kathleen Collins
Ray Mallor
Viola Daniel
"Big Boy" Williams
Wm. A. O'Connor
Fannie Midgely
Mario Majeroni
Russ Whital
Alice Chapin
Julia Hurley
Mark Gonzales
Aurelio Coccia
GEO. A. MCDANIELS
RUTH CLIFFORD
Ethel Lyons
Joe Janecke
Mr. Abbott
Miss Hamilton
Fred C. Jones
Hope Sutherland
Clover Ames
Kate Blancke
Walter Gray
Russell McDermott
Rod LaRocque
Tommy Carey
Walter Schoeller
EUGENIE FORDE
EDWARD J. BRADY
LILLIAN HAMILTON
Geo. Williams
Kenneth Thomson
Louis Natheaux
Louise Cabo
Anthony Merlo
Clay Clement
Florence Malone
Louis Reinhart
T. Tamamato
Charles Dewey
Helen Russell
TOM TYLER
FRANKIE DARRO
DUANE THOMPSON
EDWARD HEARNE
TOM LINGHAM
Bonnie Hill
Harold A. Miller
Trueman Van Dyke
James Barrow
Dagmar Godowsky
Flora Holister
William Brown
Clayton Hamilton
Leo Willis
Naida Carle
Walter Lantz
Edward Jones
Joe Tremway Lewis
Edward B. Tilton
Larkins Gilbert
Harry Loomes
Landers Stevens
AIME SIMON-GIRARD
PIERRETTE MADD
CLAUDE MERELLE
MONSIEUR DE MAX
HENRI ROLLAN
MONSIEUR MARINTELLI
P. DE GUINGAND
JEANNE DESCLOS
Van Dyke Sheldon
WILLIAM WAGNER
Kate Conlan
HARRIET HAMMOND
LEW CODY
RENEE ADORÉE
PAULETTE DUVAL
Gerald Grove
Jacqueline Gadsden
Winston Miller
Jane Mercer
Irving Hartley
Dagmar Desmond
Leonic Lester
Violet Schramm
Muriel Parker
Sam DeGrasse
Doris Duane
Priscilla Moran
Joe McCray
Norma O'Neil
Frederick Truesdell
G.M. ANDERSON
Louis Bennison
Samuel Ross
Neil Moran
Barbara Allen
Flora Zabelle
Leila Romer
Edward Bernard
Mrs. Wallace Wyckine
Richard Johnson
Dan Baily
Alice Smith
Emil Roe
William Gaxton
T. Henderson Murray
Warren Cook (Charles McGee)
T. Tamanote
George Wright
Thomas Guise
Beryl Boughton
Harry Blaesing
Franklyn White
Peter Barett
Wilfred Lytell
Bessie Stinson
ESTER JACKSON
Guy Austin Tower
Robert Westover
Charles Graham
Wm. Cavenaugh and E. W. Hanna
U.K. Hout
Bobbie Ray
Harry Mc Coy
Dudley Hawley
Edna Earl
Manuel Paquito
Jean Dixon
Charley Bowers
Corime powers
Jack Burdette
Dan Duffy
Eugenie Ford
Nicholas Cogley
Constance Wilson
Knute Erickson
Oscar Shaw
Robert Murdock
Daddy” Manley
James Donnely
Fat Lobeck
William Burt
Nigel De Brullier
Geo. MacQuarrie
Mabel Bunyea
Muriel Ostriche
Walter Green
Edward Elkas
Helen Wheeler
Conrad Carson
Hector Dufrane
Eva Nelson
Albert Spalding
Clara Beyers
Rosemary Dean
Helen Wolco
L.C. Shur
Benjamin Hopkins
Julian Lamothe
Billy Bevans
Sheldon Lewia
Alexander Carr
Vera Gordon
Betty Blythe
Bill Winton
Rose Marie de Courelle
Micky Moore
William H. Cavanaugh
Charlotte Russe
William H. Sloan
Harry Vokes
Billy Garrick
Herbert Gale
Violet Masterson
Hal Garrett
Hugh Garrett
Agnes Norton
F. J. Titus
Doc’ Crane
Bob Mack
Harry Spear
Lester Sutherland
unknown
Jim Welch
James Rook
Wm. Lester
Andre' Tourneur
Claude Payton
Goldie Madden
ELLA HALL
RICHARD RYAN
EDWARD HEARN
MARCIA MOORE
Mary Ladislas
Hugh Whittaker
Walter Craven
Adele Clinton
RICHARD SHARPE
Mr. Fred Terry
Laurance Wheat
Gus Weinburg
Ernest Lawford
John Broderick
Louise Farley
Richard Davis
Helen Blaney
Mrs. Robert McKenzie
BOB STEELE
Lillian Gilmore
Jay Marley
Theodore Henderson
Nat Mills
Silent
Robert Harrington
Edward Marle
ANNA LEHR
NORVAL McGREGOR
FRANK NEWBERG
RONALD BRADBURY
SEYMOUR ZELLIFF
Betty Boyd
Dennis Eadie
Cyril Raymond
Fred Morgan
Cecil M. York
Arthur Cullin
A. B. Imeson
Daisy Cordell
Evelyn Harding
Dorothy Bellew
Mary Jerrold
EILLE NORWOOD
Mme d'Esterre
Mollie Adair
Laurence Anderson
Jack Selfridge
Bob Harrison
Frances Buckley
Gerald Baker
Henry Buckley
Eugenie Silbon
Maurice Kains
Kathryn Browne-Decker
Clara Whipple
Marie Reichardt
Fred Esmelton
Beniamino Gigli
M. MacQuarrie
Arthur Moon
Halel Buckham
James B. Leong
Buddy" Post
Naldo Morelli
Harry Ostermoore
Phylis Allen
Beartrice Lovejoy
Harry Burns
Lucille Smith
Adèle Farrington
Leigh Wyant
Jane Starr
Margaret Vilmore
Wm P C arleton
Robert Kelly
Ed Gibson
M. T. Head
Harry Keaton
Slim Peppercorn
Dct Farley
Grace Valentine
Catherine Tower
Edwin Barbour
Mrs. George W. Walters
Peter Long
Edwin B. Tilton
Mrs. Ward
Joe Manning
Wm. Scott
Edward Durand
Harry Kattenberry
Bob Churchill
Bill Houghton
Dr. Jessie Houghton
Dr. Boynton
Daffy Jim
Haywood L. Kees
Dallas Valford
J. L. Smith
Margaret Mann
Dorothy Hagan
Margaret Adair
Harry Rattenbery
BILLY GARFIELD
JACK BLAKE
JIM SHAW
MARIE SHAW
WILL ROGERS
C. E. Mason
H. Milton Ross
C. E. Thurston
Burton Halbert
LEX WILMOUTH
Liela Frost
Mrs. Magee
Richard Goodloe
Colonel Sanders
Harry Ionsdale
Fred Bernard
Chas. Hamlin
Jessie Steward
Mabel Emerson
J. Webb Dillon
Peggy Shanor
Kathleen Kirkman
Harry Northrup
Robert Boulder
FRANKLYN PARNUM
VOLA SMITH
CLARISSA SELYN
Constance Binney
J.W. Johnson
Bigelow Ccooper
Ned Hay
Alma Aiken
Fred Miller
Jo Farrell MacDonal
Jean DeBrinc
Edw. J. Brady
Joseph Ray
Jesselyn Van Trump
Al. Whitman
Eugenia Besserrer
Patricia Barton
Lester Swope
Vera Owens
Mattie Commont
Edwin Baker
Dora Barton
Muriel Martin-Harvey
George Foley
J. R. Tozer
Arthur Cullen
Gregory Scott
Billie Burke
A. J. Herbert
Benjamin Deely
Vivian Prescott
Florence Crane
John Dugley
E. J. Connelly
Fred C. Truesdell
Henry Kolkèr
Baby Ivy Ward
Andrew Clarke
Mrs. Hunt
Fred R. Stanton
William Caffney
J. H. Forsell
J. C. Dunn
Frank Mood
William Willis
Aubrey Lowell
Raymond Hayes
Fred T. Des Bresay
Antonio Vitolli
John Laffey
William Smith
Richard Dorsey
Harry Pettibone
Mickey McBan
Nils Aster
Mary Nolan
Fred Radcliffe
Frank Lee
Fredi Verdi
J. H. Gilmore
Isabelle Berwind
KATE WITTENBERG
ROSE WESTPHAL
ERWIN NEUMANN
BERND ALDOR
ELAINE HAMMERSTEIN
Tom Brook
Iva Forrester
Hank Bell
Bartine Burkette
Kenneth MacKenna
Ann Pennington
Kitty Kelly
Dick Hatton
Marilyn Mills
Gerry O'Dell
Clara Morris
Don Cameron
Edith Shayne
Frank Goldsmith
Harold Foshay
Kay MacCausland
May Cirmol
Kthol Wales
Burton Holmes
Robert Carewe
Allan Crolius
Franklyn Hall
Miriam Burke
Esther
Mrs. Burke
Lee Thurston
Alice Page
Eddie Somers
Howard Mason
Richard Van Norman
Malcolm Somers
Reynolds
Schuyler Ladd
Ferd Tidmarsh
THOMAS CARRIGAN
Bill Harding
Jane Courtney
SID TAYLOR
Marcia Avery
Neil Hardin
Herbert Prier
Mlle. Karnareck
Hayward Jack
American, Dick Gray
Walter Stevens
Mary Moore
HILLIARD KARR
HARRY McCOY
Joan Crawford
Edith Chapman
Robert Caine
Stanelly Wheatcroft
Norman Selby
Anna Mirrel
Jack MacDonald
Norris Johnson
Norman Hammond
SAME BROCKTON
GRACE DARLING
HOWARD DANA
OLGA
DANIEL DARLING
MRS. DARLING
Jeanie Van Graath
Ethelida Baring
Irene Shannon
Jackie Morgan
Mitchell Harris
RICHARD BENNETT
Adrienne Morrison
Maud Milton
Jacqueline Moore
Geo. Ferguson
Jos. J. Gerard
Baby Rube
Mr. Lewis S. Stone
Mr. Wallace Beery
Mr. Melbourne MacDowell
Miss Ruth Renick
Mr. Wellington Playter
Mr. DeWitt Jennings
Mr. Francis MacDonald
Little Esther Scutt
Jose Rubens
Annette Bensen
Clifford Grey
Frances Nemoyer
Rodney Eclair
Emily Gerdez
Virginia Warwick
William Beerdheim Van Broon
Tom Tarney
Buck Stringer
Bruce Crosby
Ama Carlton
Grafton
Ruth Lackaye
Ralph W. Ince
Theodore Von Eltz
Mavis Cole
Wm. B. Davidson
Dorothy Grosscup
Colín Campbell
Grace Parker
Miss Anna Pezzullo
Alberto Danza
Carmela Cecchi
Linda Checchi
Lonilda Cecchi
Gennaro Granese
Vincenzo Ruso
George Swann
George De Carlton
James Davis
H. E. Hebert
R. A. Roberts
Miss June
John Cook
Anthony Arnold
Bess White
Sam Price
Charles Garry
Elaine Justice
Adam Justice
Arnold Becker
Leona Page
Frederick Baxter
Mr. Crittenden
Al. Moranti
Allen Kent
Mlle. Maresi Dorval
Georges Chebat
Margaret Fischer
HARRY POLLARD
G.H. Gray
Volma Whitman
Norman Napier
Geo. W. Chase
Charles Cranner
Anna Jones
Dick Jones
Stub Lou Tate
Shorty Fuller
Maenie Wade
Zed White
JETTA GOUDAL
Victor Varconi
Kathie Discher
Harry DeVere
Mr. Tedmarsh
Byron Munson
Helen Howard
Jack Stewart
Marvin Loback
Walter Bytell
Richard Pennell
Earl Lynn
Buster Collier
Helen Hoge
Ed Burns
Bess Holbrook
Robert Rendel
Lincoln Steadman
Jeanne Calhoun
JEAN DE BRIAC
Al Roscoe
Blaise Willard
Harry Rice
Eleanor Fields
Unice Vin Moore
Benjamin Haggerty
Edward Martindale
John Prince
W. H. Brown
JOE HARRIS
ANNA MAY WALTHALL
HOWARD ENSTER
Hugh Allen
David Torrence
Lewis Dayton
Joyce Compton
Beulah Baines
Patricia Magee
Kate Tonoray
Minna Redman
Helen Pillsbury
RUTH ROLAND
FRANK MAYO
Basil Rathbone
Elizabeth Bu#bridge
Edward ARnold
Beatrice Tremaine
Queenie Rosson
Frank Wallace
Howard Lang
P.E.Peters
Milton Brown
Dick La Strange
Gerald Ward
James Cruze
Loretta Truscott
Joseph Bingham
Cladys Leslie
Ida Ward
Jack Dean
Alice Ardell
Roderick LaRoque
Bob Clark
Irma Grant
James Matthews
Edna Whistler
Isabelle Berwin
Joe Simkins
Harry Norman
Doris Heywood
John Delson
Mrs. Adler
Geo. S. Trimble
Wm. Rauscher
Geo. E. Bunny
Minnie Prevost
Thomas Smith
Al. Ebrite
IDA DARLING
PHILLIPS TEAD
CHAS. GIRARD
TEMPLAR SAXE
MAUDE HILL
DOROTHY WORTH
GEO. STEVENS
RUTH WAYNE
Jimmy O'Shea
J. J. Bryson
Louise Klos
Jeannette Rogers
Anna Timmer
Margaret Louisa
Bessie Loomis
Charles Butterfield
Bruce Lemon
Tommy Tremaine
Mary McCall
Muriel Ruddell
HARRY DUNNINGTON
Elsa Saranol
Homer Saranol
Nathan Bonner
Gloria Payton
William A. Hackett
G. B. Williams
Joseph Olancy
Irene Tylor
Carlyn Wagner
Lilian Harrington
Mrs. John Harrington
Billy Travers
Stuart Winthrop
Donald Kerwin
Marjorie Kerwin
Claire Briggs, cartoonist
Ray Rohn, illustrator
H. T. Webster, cartoonist
Franklin P. Adams ("F.P.A.") newspaper columnist
C.D. Williams, illustrator
Marc Connelly, humorist and playwright
C.F. Peters, artist and illustrator
Shirley Marvin
Ned Leo Maloney
Robert McWade
Fred Walton
Tom Vernon
Ida Vernon
Jeannette Lawrence
Dave Anderson
Gladys Ballard
Gordon Lewis
John Henry Jr.
Mia May
Albert Steinruck
Alfred Gerasch
Paul Bildt
Dyumar Van Twist
Otto Treptow
JACK LUDEN
GRANT WITHERS
YVONNE HOWELL
RO SALIND JOY
JACK JAMES
MISS POLAYRE
Henry Roussel
M. Cesar
Fay Holdner ness
Laura LaVarnie
Marvel Rae
Emett C. King
Peggy Pierce
Doris Whitman
Sharron
Walter Keane
Bob Gilmore
IRMA KEITH
JACK HALDANE
NAN FOSTER
JIM FOSTER
Jerry Mandy
Mary Holmes
Jimmy Hale
Amos Bixby
Etta Mason
Dora Bixby
Mrs. Bixby
RANDLE AYRTON
Tom Garvin
Enid Benton
Pina Nesbit
Lilah Chester
William Faversham
THOMAS FLYNN
JOYCE FAIR
Tommy Harper
Muriel Yerke
Eric Le Blanck
Henry Shorb
Sally Starr
Chas. West
Jule Power
Eot Payne
Jean Vachon
Finch Smiles
Marga La Rubia
Tex Trapp
Ernest Maupin
Danny Hogan
Joseph Ricksen
Buck Black
Billy Franey
Clarence Jonstone
Bill Binks
Tom Binks
Henry Peck
Lillian Peck
Kart Barner
Chas. Hill Mailes
Frank Deshon
Ed. Brown
Charlotte Burtm
Robert Klein
Cora Morrison
Cupid Cavens
Dorcas Matthews
Roland Lee
Donald McDonald
E. ALYN WARREN
T. ARNLEY SHERRY
MME. ROSITA MAISTINI
BEATRICE VAN
J. H. Goldworthy
Eric Maxon
Melville Stewart
Reginald Owen
Hilda Trevelyan
Wynndham Guise
Mary Jane Milliken
Lew Sargent
Wm. Gillis
Orville Caldwell
Frank McGlynn, Jr.
Mabel Thummelle
Helen Coughlin
I. de Castro
Harry Chira
Evelyn Sherman
Garry O'Dell
Fred Humes
Mrs. H. R. Hancock
Mr. Russell
Fred Goodwin
Margaret Landis
Catherine MacDonald
Dorothy Granville
Albert Roscoe
Zella Caul
Joe Drummond
LEONARD CLAPHAM
JIM COREY
Charles Girard
Marguerite Courtot
Florence Fauville
Edna May Oliver
Anthony Jowitt
"Gunboat" Smith
Thomas Santtschi
Horace Carpenter
Miss Sackville
Mr. Murphy
Miss Cecil
Jack Connoly
Eyton
REGINALD DERNY
Herr Gruder
ASTA NIELSEN
Herr Berger
Meffert
Sacks
Frau Schel’er
Lumbye
Alice Washburn
Elsie MaeLeed
Blanche Chapman
Leon Kent
Fred Gamboal
Thomas W. Ross
Francis X. Conlan
Lionel Pape
Jack Crosby
Louis Sealey
Gladys Coburn
Thea Talbot
Florence Court
Marie Shaffer
Rex De Rosselli
Phyllis Titmuss
Alfred Woods
Emily Nichols
Owen Roughwood
Sydney Fairbrother
Albert Chase
Tio
Madge Stuart
Hubert Carter
Mrs. Hubert Willis
Irene Tripod
Nancy Deever
Nadine Nash
Thomas O'Malley
Mathew Betts
SONYA MARTINOVITCH
MAHMUD HASSAN
MILOS MARTINOVITCH
MARKO MARTINOVITCH
MILKA
Pauline French
D. R. O. Hatswell
Lorimer Johnston
Isabel Elson
Harlan E. Knight
Judith Vasseli
Franklin Hall
Aileen Allen
Belle Hutchison
Lee Arms
Fred Hume
Marion Wells
STRONGHEART
Peter Coe
The Missionary
Jean Metcalf
Evangeline Bryant
Lady Silver
Howard Burton
LARRY SEMON
William Gillespie
B. F. Blinn
"Babe" Hardy
Curtis McHenry
HENRY WILTON
VIOLET DE VERE
ETHEL STANNARD
CONRAD NAGEL
JACK DEVEREAUX
JACK CAGWIN
HELEN LOWELL
Mr. Cajus Brunn
Mr. Robert Dinesen
Miss Ebba Thomsen
Miss Gyda Aller
Lillian Gish
George Hassell
Matilde Comont
Gino Corrado
Gene Pouyet
Catherine Vidor
Valentina Zimina
DORIS RANKIN
OCTAVIA BROSki
THOMAS BRAIDON
KATHERINE STEWART
MAYBETH CARR
CHARLES LANE
JED PROUTY
E.J. RADCLIFF
IVO DAWSON
Harriet Notter
Anzinette Moore
Willie Belmont
JANVIER
JOFFRE
JEAN DAX
CROUÉ
Helen Clay
Herbert Warren
Sir John Martin Harvey
Frederick Cooper
Betty Faire
Ben Webster
Jean Jay
C. Burton
Gordon McLeod
Fisher White
Mary Brough
Harold Carton
Judd Green
H. Ibberson
Fred Rains
Martin Conway
Margaret Yarde
Michael Martin Harvey
ALICE JOYCE
G. V. Seyffertitz
Edith Campbell Walker
Dan Comfort
Dick Rosson
Ernest Morrison
Mary Salsbury
Paul Chandos
Philip Sleeman
Mathilda Landage
Renzo Gardi
Bernard Seigel
Florence Renart
Ralph Bell
Joseph Hazelton
W. K. Mesick
W. F. Moran
Thomas Hadley
Dick Connors
Chet Withey
Charles Morten
D. Henderson
Madge Kirly
Mrs. D.
Iris Van Suydam
Anno Schaefer
Juno and Jean Prontis
Minnie Kloter
Mr. Witting
JACK PICKFORD
ALEC B. FRANCIS
HERBERT PRYOR
ANN MAY
GEORGE DROMGOLD
Grace Benham
CHARLOTTE WALKER
EARL FOX
DICK LE STRANGE
Harry Leoni
A. Voorhes Wood
Arthur Kennedy
Miss Cox
A. Tokunaga
Mrs. Ida Waterman
Thelma Converse
Fraser Coalter
Catherine Proctor
Wilfred Donovan
Billie West
Bid Jordan
Francesca Bertini
Mrs. Gemma de Ferrari
Alberto Collo
Vittornia Moneta
G.M. Anderson
Ella McKenzie
Rodney LaRoque
Richard Lang
Wm. Desmond
Laura Larlante
Frank Lyon
Earl Page
Lucritia Harris
BARNEY WEBSTER
ANABEL KNIGHT
DOROTHY ARMFIELD
HAROLD TAYLOR
George Ali
Philippe de Lacey
Jack Murphy
Irvin Renard
Earl Haley
Caryl Cushman
Marie Le Manna
ROSE DIONE
GEORGE MCDANIEL
GEORGE SEIGMAN
WILL JIM HATTON
JAMES O'BARROWS
RUTH KING
KATE TONCRAY
LILLIAN RAMBEAU
PAULINE STARKE
RUTH ASHEY
Golda Colwell
Geo. Chesbro
Miss Juanita Hansen
Sally Blane
Richard Carlyle
Scott McGee
Corinne Lessler
Jacob Mott
D.L. Don
John J. Dclson
Jules Cowles
Zula Ellsworth
Hamilton Revelle
William E. Shay
Karen Hansen
LEILA COLE
MIGNON BRUNNER
FORREST STANLEY
Alice Terry
Norman Kennedy
Violet Palmer
Leonora Ottinger
Francis Reilly
WM. GAIWOOD
VIVIAN
HARRY V. TIER
JACK
LOU
Rosa Gore
C. W. Ritchie
V. Pasquali
Roland Rushton
Fanny Stockbridge
Laura Lavagnie
Marshall Ricksen
Robert Devilbiss
J. Park Jones
Marie Moorehouse
Billie Cotton
Alfred Ferguson
Frederic Vroom
CHUCK O'CONNOR
SADIE O'CONNOR
ANNIE MALONE
JIM CANFORD
Dixon Lee
Teddy Ransom
Jose Morilla
Nina De La Guerra
MARTHA SLEEPER
Gunnis Davis
Olita Otis
Marguerite DeLaMotte
Sidney DeGrey
Pat O’Malley
“Spec” O’Donnell
OVEN MOORE
HELENE COSTELLO
Kathryn Perry
James Carroll
U.K.Houpt
Jim
Carol Myers
ERNESTINE SCHUMANN-HEINK
Emma Gerdez
Fred Abbott
Jay Dwiggins
Billy Elmer
Ed Brownell
Joe Young
Sidney DeGray
Mary Gordon
Florence Wix
Barbara Clayton
Roy Stuart
Miss duPont
Barry Grasby
Ella Magee
Frances Mann
Denton Vane
Miriam Miles
Norbert A. Mylos
Lucie K. Villa
Clara Horten
Fred Hoarne
Lindsay J. Hall
Manny Ziener
Dick Swift
Milly Swift
Adolphus Smiley
Mrs. Dacre
Mary Churchill
David Swift
Thomas O'Brien
William Lloyd
Pierre Le May
Catherine Calhoun
George Waggner
Ruth Miller
P. R. Butler
AUDREY MUNSON
Gertrude LeBrandt
Thomas Carr
Laura West
Marie Francis Bussey
Rose Gore
Craig Ward
Ralph Cloninger
See Shumway
John Dill
Gordon Magee
Otto Nelosn
M. B. (“Lefty”) Flynn
Jim Crosby
John Payton
Temple Vaughn
Phil Johnson
Tom Merrill
Mary Harper
Sid Jenkins
F. Coleman
Al Ray and Phil Dunham
Virginia Rappe
George Rowe
Susanne Avery
Bob Caster
David Dunbar
Mary Bath Milford
Emily Barry
Mrs. Moore
Miss Johnson
C. E. Horn
Evelyn Nesbit Thaw
Margaret Risser
Jack Clifford
William Russell William Thaw
Joseph W. Standish
Christine Francis
LOWELL ROBINSON
OLAF OLSON
KATHERINE DEXTER
RODNEY SHERIDAN
Joe Simpson
Vicky Simpson
Pete Johnson
Tom Smith
Chet Ryan
Albert Hackett
Jay Herman
Billy Sheer
Janet Sully
LLOYD HAMILTON
Horace Neumann
Robert DeVilbiss
Bill Bevin
Donald Cass
Chas. (Heinie) Conklin
Gilbert Clayton
Taylor Duncan
SEYMOUR HICKS
ELLALINE TERRISS
Peggy Adams
William Chatterton
Ivan Christie
ADD A GLEASON
MR. FOXE
MISS CLIFTON
JACK PERRIN
Anna Darling
Phil Duncan
Hova Gerber
Kathryn Wilson
Emily Stevens
George LeGuere
Theodore Babcock
Eftingham Pinto
Del DeLouis
Ralph Austin
Edwin Martin
Baby Field
Adelaide Hayes
Hebert Fortier
Pierre Gendron
Ben Hendricks
FRED E. NANKIVEL
DOT EDNA HAMMEL
Hugh Metcalf
Mme. Claudio Zambuto
Mlle. Line de Chiesa
M. Marius Ausonia
M. Annibal Durelli
WINTER HALL
GRETCHEN LEFERER
ZOE RAE
George Macquarrie
Charles Dungan
MARTHA MCPHERSON
Lillie Clark
Little Audrey Littlefield
Lea Erroll
Mrs. Radcliff
Frank Hatton
Jim Kyneton
Nick Kyneton
Ted Brooks
Jennie Lee
Helen M. Hayes
Edmond Cobb
Burt Maddock
William L. Abingdon
Robert Elliot
Victor DeLinsky
Daniel Sullivan
ALFRED ALLEN
R. MORRIS
H. SKINNER
FRED WHITTING
Henry Victor
Alice Delysia
Jack Denton
Sydney Bland
Blanche Forsythe
Nastings Batron
Buster Brown
Buster's dog
Carl Silvera
Len Trainor
GEO. PERIOLAT
Leila Parker
Bob Curwood
Jane Fernley
Vivian Presco
Bernarr MacFadden
Marion Dentler
Frank Glendon
Harry Semels
Toy Gallagher
Winthrop Halsey
Blevin
S. MILLER KENT
SID SAYLOR
Rene Adoree
Fronzie Gunn
Bebe Hardy
Oliver
Richard Nolan
Margaret Cullington
Billy Safford
Cyril Naughton Webster
Mrs. Geo. Hernandez
Fred C. Treendall
Mr. Cavanagh
Eoh Payne
V. T. Henderson
Dallas Welford
Geo. Periolat
Jas. Harrison
Wallace Kerrigan
John Simpson
Jim Hardy
Carl Lindsay
Marie Simpson
Steve Tucker
Jim Saunders
Helen Coburn
Percy Winthrop
Joe
Missouri
Al Hickman
Nan Christy
Otto Okuwa
Louise Lee
John Nelson
Richard Morris
Robert Kortman
Clara Blandick
J. J. Williams
Dot Hazelton
Jeremiah Crozier
Edward Hazelton
Andy Clark
Howard Maximier
Lloyd Carleton
Jerome LeGasse
DeSacia Mooers
Sherman
Nichols
Lillian Elliot
JERRY STEELE
Ginger O'Hara
Bob Crew
Hanzup Harry
Silent "Oklahoma" Joe
Pat O'Hara
By Himself.
Nelson Ramsey
John Blakely
Hal August
Peggy Cordray
Alva Blake
Raymond Russel
Sis Mathews
ART ACCORD
Miss Maddox
Marvel Spencer
Frank Baker
RICHARD CHESTER
NORAH ELLIS
CHARLES RENALLS
EVERARD PECK
Olive Fuller Gordon
Thomas Aiken
John Wilson
William Barrett
Frank Storm
Pete Lear
Steve Baker
Jennie
Buster Trow
ALICE HOWELL
Marquerite Clayton
Bill Hayes
William Milan
Toby Claude
E.J. Ratcliffe
Robert Ricketts
Grace Stanton
Colonel Stanton
Jimsy May
Reaves Eason, Jr.
George McDaniels
Fontaine LaRue
Irene Fenwick
Reine Davies
Sarah McVicker
Little Joan
Pedro Leon
H. B. Carpenter
Barnard Powers
Allen C. Holubar
DAVID DRUCE
DOPY DICK
Mrs. Carter De Haven
King Baggott
Freya Sterling
BOBBY DUNN
Ed. Barry
Gladys Vernon
Teddy O’Neill
Eileen
Phadrig O’Toole
C. Wm. Bachman
Kathleen Zirkham
Michael Dark
DORIS LEE
CARL ULLMAN
CHAS. FRENCH
ROBT. GORDON
Joe Dowling
Olive Hasbrouck
Ivar McFadden
C.Elliott Griffen
Marjorie Maurice
E. Pasque
Pat Foy
Mrs. Foy
Jean Shelby
Richard Bolton
JOSEPHINE HILL
NORMAN HAMMOND
William Frederic
Mabel Trunelle
W. L. LEWIS
ELEANOR BLEVINS
Jean Hathway
Fatty" Arbuckle
Winfred Greenwood
J.M. Dumont
Edward Sutherland
Henry Johnson
Karl Silvers
John King
Harry Timbrook
Loyette Merval
Willard Standish
Henry Laurens
Toto Ducrow
Lillian Herbert
Guide Celucci
T. Tamameto
Lina Davril
DOROTHEA ABRIL
GERTRUDE SHORT
C. H. GELDERT
CAMILLE ANKEWICH
GEORGE L. SPAULDING
William Cannfield
Henry Hull
C. H. Crocker-King
Frank Sheridan
Irma Harrison
Herbert Sutch
Percy Carr
Charles E. Mack
Jps. Rich
MARGARITA FISCHER
Thos. Wise
Betty Wise
John Thorn
Johnnie Cooke
Robert Lawler
Jacques Jacoard
Rex Cherryman
Consuelo Flowerton
Mrs. Oliver
JACK DEMPSEY
ED'SEDGWICK
BELLE BENNET
JACK FRANCES
TOM WEBKE
Walter Harker
Edith Ransom
Mammy Peters
MARY MERSCH
FLORENCE SMYTHE
MRS. LEWIS McCord
RENEE ADOREE
Charley Chase
TOM MOORE
Guy Empey
Florence Evelyn Martin
Vera Boehm
Frederick R. Buckley
RUTH HECK
LEM HECK
TIMOTHY HOOD
JOHN MOUNT
Jennie Ross
Cyclone Smith
Gunner Wray
Bob Anderson
William Cohn
Joseph W. St
James Cassid
Princess Red Wing
Frankie Evans
Jos. Smiley
Blanche Craig
Ed. Rosemon
Monya Audree
Corinne Powers
Arthur Dewey
Magie Willis
Eddie O'Conner
Charle Hartley
JACK NOLLY
BERT WILSON
BOB GRAY
Carroll McComas
Vivian Perry
Harold Meltzer
Clifford Pembrook
Franklin Bellame
Frank Mills
Mrs. Mathilde Brundage
Augusta Perry
Harry Linson, Ben walker, and John Cohill
Luke Cosgrove
Warren Rogers
Leigh Willard
Zelma O'Neal
Rodney St. Clair
Larry Gastlen
Aguste Burneister
Frank Beamish
Geo. McQuarrie
Ada Price
William Ruggles
Ruth Downing
Louise Long
Dick Downing
Georgia Hale
Jack Ramond
Nina Cassavant
Josephine Sedgwick
Muriel Frances Dana
George Barraud
Gene Carrado
EDNA GOODRICH
WILLIAM HINCKLEY
FRANK GOLDSMITH
CAREY LEE
ESTHER EVANS
NELLIE PARKER SPAULDING
MRS. BRUNAGE
Wilbur Highboy
Roy Laidlow
GEORGE ARLISS
Miriam Battista
Mickey Bennett
J. B. Walsh
James Lackaye
Ruby de Remer
Rollo Lloyd
Will Louis
Vincent De Pascale
Harry Rice and Pete Bell
Mother” Benson
Kada-Abd-el-Kader
Alex Nova
Mlle. Kithnou
Michael Brantford
Rosita Ramirez
Fredrick Mariotti
Madame Paquerette
Fernand Mailly
Andre von Engelman
Annabelle Magnus
Catherino Smith
Edward Early
Lucillo Early
Eva Johns
Tom Trainer
Hilda
Isaacs
Julia
Habel Dwight
Nellie Grant Robinda Baulbridge
Grace Morrissey
Billy Ritchie
Jerome Ash
Katherine Jordan
William Gillette
Robert Harron
Earl Carroll
Albert Barrett
June Fuller
Adolf Edgar Liche
Harry Liedtke
Verner Bernhardt
Guido Hersfeld
Viktor Janson
MARY NELSON
CHARLES SUTTON
NELLIE GRANT
DICK THURSTON
Paul Chester Barnett
L. S. McKee
CYRILLA DREW
William R. Otis, Jr.
Edward Peil, Jr.
James A. Marcus
Claire Mc Dowell
Joseph Belmont
Wilkens
Walker
Pete Lang
Tom Potter
Fred Holmes
Ervin Renard
Carl Silvero
Teroy Scott
Jack, Richardson
Billy O'Brien
John Strong
Fritz Brunette
Georgia Oliver
Juliette Compton
Jeon de Limur
Russel Thorndike
Warwick Ward
Ann Schaefer
Mary Louise Miller
Horman Selby (Kid McCoy)
Marie Tropic
Tote Ducros
Julien Barton
Thurlow Brewer
Rose Cade
Roscoe "FATTY" ARBUCKLE
Al. St. John
Joe Keaton
Wm. Hutchison
Scott Dunlap
Wm. Atkinson
Luke Scott
Mattie Edwards
D. Rosebourough
Fuller Golden
Cleve Morison
Marcella Corday
GUY NEWELL
SERGE LAOLOFF
MICHELINE POTOUS
SENO GARCIA
NINA
CAMILLA
JOSE
MIRIAN SHELBY
LEE HILL
E.N. WALLACK
L.M. WELLS
RAY HANFORD
Lucy Cotton
Stephen Grattan
Rae Allen
Barnet Parker
Arthur Hausman
Miss Violet Van Brugh
Lucile Gray
Chai Wong
Frances Sanson
Earl French
EDWARD ROYLE
HARVEY WILSON
DAVID PIERCE
EDITH PRESTON
MRS. PRESTON
MAYME KELSO
Jack F. McDonald
“Hoot” Gibson
F. O. Galvez
Wm. Elmer
Jos. W. Gerard
Sonia Marsell
Prince Gautier de Severac
Hayes Robertson
Harland Tucker
Edith Carlyle
Hope Hampton
John Garson
Bennett Barton
John Warren
Dolly
Simpson
Nora Reed
Warner Greene
Lenora Ottinger
Frank Smiley
Eddie
Gray
Mary Warren
Victoria Foxie
Charloti
George Fisk
Josephine Di
Ethith Borell
Pete Clark
Alys Mason
Harry Fisher
Ed. Curzon
Katherine Campbell
Bobby Culbertson
Earl Unkraut
Lillian Beck
Bert Crawford
Pete Raymond
Selma Kinmar
John Woodford
Nobert Myles
Edward Brown
MILDRED DAVIS
Bill Strother
Westcott B. Clarke
Virginia Ware
Harold Miller
Rudolph Christians
Henry Woodward
Mickey Daniels
Kewpie
WELLINGTON PLAYTER
SPOTTISWOODE AIKEN
Betty Hampton
Joe Melford
Dick Younger
Lillian Concord
William Roselle
Mary Louise Beaton
Frank Strayer
Dave Baxter
Steve
Dick Lonagan
Miss Vera Roehm
Miss Margaret Crawford
JOHN CHARLES
MARY ROBSON
GEORGE BACKUS
FORREST ROBINSON
EDGAR NELSON
EFFINGHAM PINTO
Frederick L. Konler
JANE WOLF
Miss Manning
MISS EMILY FITZROY
MISS LOUISE FAZENDA
MR. ARTHUR HOUSEMAN
MR. ROBERT McKIM
MR. JACK PICKFORD
MISS JEWEL CARMEN
MR. SOJIN KAMIYAMA
MR. TULLIO CARMINATI
MR. EDDIE GRIBBON
MR. LEE SHUMWAY
Hockliffe Fellowes
Roger Pitney
John Junior
Grant Mitchell
Renee Clemmons
Marion Hoyte
James Lodge
Clifford Trent
Dertha Harmon
Shipley
Joe Harmon
Gwendolyn Shipley
Leroy Howard
Ruth Lodge
Delle
Arthur Gibson
Laura Lapante
John Watts
Inez Carillo
Terry Owen
Wm. Humphreys
Joseph Murdoch
Bill Scott
Walter Ackerman
James Donnelly
LUPINO LANE
Garfield Thompson
CLARA HORTON
WILLIAM COURTRIGHT
ALBERT COOKE
GEORGE LAVIGNE
J. Lindsey Hall
John Doe
Gertrude
Gladys Tennyso
Gertrude Griffith
Russell Medcroft
I. Ritchie
Renee Adoreé
Delbert Emory Whitten Jr.
Lee Morar
Priscilla Dear
J. FARREL MCDONALD
TED BROOKS
WINIFRED WESTOVER
CHARLES LE MOYNE
Edward J. Connelly
Wallace Mac Donald
Florence O'Boyle
Philips Dunham
Gus Leonard
Lorraine Bason
Thelma Hill
Almerin Gowing
Darmy O'Shea
Gipsy Hart
Charles (Chic) Sale
ALLEN HOLUBAR
ED BRADY
MAUDE EMORY
H.B. EDMONDSON
"BUSTER" EMMONS
Burton Churchill
Nick Thompson
Jerry Devine
Kate Mayhew
Chas. Dorian
Etienne Girardot
Peggy Martin
Geo. Berrill
Einar Hansen
Cora Macy
Paulette Day
Lyster Chambers
Hugh Jeffery
Charles Bowser
Harry Mayo
C. W. Herzinger
Leonard Trainor
James O. Barrows
Agnes Glynne
Fred Paul
A. Robson
Bob Emonds
Miss Dominguez
JACK WOODWARD
LOUISE LESTER
CHARLES MORRISON
James Frederick Slocum, Jr.
Ethel Wheeler
James Frederick Slocum, Sr.
Henry Fowler
Katherine Fowler
Jasper Kennedy
Charles “Kid” Miller
George Backus
Henry Sedley
Irvil Alderson
Bettie Compson
W. M. Armstrong
Walt Hiler
Bess Browne
LILA LEE
Larry Wheat
Charles Dow Clark
Max Figman
Zelma Tiden
Sidney Paxton
Jack Terry
Leslie Hunt
Isabel West
Clayton Frye
C.K. Van Auker
Claire McCormack
Gennieve Arrellanes
Jack O'Brien
Arthur Nelett
Grace Knight
Harry Edmondson
ADOLPHE MENJOU
MARY MACLAREN
NIGEL DE BRUIJER
WILLIS ROBARDS
BOYD IRWIN
LON POFF
WALT WHITMAN
CHARLES STEVENS
LEON BART
GEORGE SIEGMANN
EUGENE PALLETTE
Estella Smith
Patsy DeForrest
Margaret Dawson
Raymond Hitchcock
Raymond Hackett
Ida Waterson
LUCILLE GRAY
Baby Ruth
Louis Nielson
Alwyn Jasper
Beauty Van Sant
Fred Wagner
Alice Edwards
TOM BROCKBURN
BESSIE JORDON
VICTOR KELLOG
Sonia Smirnov
Alan Hall
Girard
Lachaise
Violet B. Reed
Morgan Jones
Norman Kaiser
Roy Pilcher
George Rout
Eleanor Blevir
Adelaide Bron
Doris Dawson
Wellington Plater
Rex Rosselli
Sebastian Maure
Ghirlaine Bellamy
Vincent Pamfort
Ilario
Annibale
Fannia
Ernesto Sangallo
ART ACORE
IVA FORRESTER
DUKE R. LEE
BEATRICE DOMINGUEZ
HANK BELL
ELENORE COLONNA
HARVEY CLARK
FRED M. MALATESTA
FRANK BROWNLEE
PAULINE CURLEY
LEWIS KING
Thelma Blossom
Thos. Commerford
Margaret Wiggin
Edith Lotimer
Billy Howe
Fred Harris
Lillian Buckingham
BENIAMINO GIGLI
Xenia Vaskova
Count Andrea Vaskova
Captain Kernova
TOBIAS YOAKUM
COLONEL STANTON
W. J. Morris
LEWIS S. STONE
RUBYE De REMER
KATHLEEN KIRKHAM
WALT R. McGRAIL
FRANK LEIGH
Tom Lewis
Frederick Santley
Wanda Petit
Christy Brehm
Wm. Canfield
Douglas Sibole
John Dels on
George Muirhead
W.R. Raymond
Florence Roberts
George Marlo
Ted Burton
Jack Arthur Johnson
Amy Lottie Briscoe
RICHARD DIX
Paul Porcasi
Kay Laurel
Will Brunton
C. Lomasey
Margaritta Loveridge
WILLIAM WADSWORTH
MIRIAM NESBITT
YALE BOSS
Jim Withers
Mr. Frederik Jacobson
Mr. Robert Schmidt
Mr. Johannes Ring
Mr. Svend Melsing
Mr. Carl Lauritzen
Beverly Hope
Mason Van Horton
Miriam Shelby
Marion Duncan
Tullio Carminati
EDWARD MARTINDEL
LAWRENCE GRANT
MARTHA FRANKLIN
Cal Cady
Mart Royce
Mary Griggs
John Pierson
Violet Day
Tom Sexton
Dr. King
Howard Log
Jack Roseleigh
Arthur Thalasso
Katherine Norton
Jerry Bunk
Liza Jane
Jonathan Swift
Colin Campbell
Sarah McVickar
Tom McNaughton
Jonathan Rodd
Frederick Rodd
Olga Merode
Ruth Margate
E. Z. Smithers
Madeline Fordyce
Joan Meredith
G. Howe Black
June Walker
June Terry
ETHEL LYNN
ED. BURNS
Charlie Winninger
Giovano Marro
Santa Marro
Giordo Colombo
Frank Newberg
Charles Stevens
Herbert Pryor
Louis Yacanelli
FRANK FARRINGTON
GERTRUDE McCOY
BESSIE LEARN
HELEN STRICKLAND
DUNCAN McRAE
MABEL DWIGHT
MAXINE BROWN
FRANK McGLYNN
Lizette Thorne
Edward Rainey
Ivor MacFadden
Gus Saville
Charles L. King
Zoe Wharton
Halsey Burnes
Judson Holmes
Margaret House
Hylda Hollis
BARNEY SHERRY
ROBERT WALKER
KATHLEEN O'CONNOR
PHIL GASTROCK
Lon Chancy
W. C. Dowlin
Dick Deacon
Betty Gray
Robert Tracy
Bart Rogers
Dick Cumming
Will Armstrong
Dorothy Wallace
Helen Sullivan
Henry Miller, Jr.
LUCILLE NEAL
JOHN NEAL
RALPH LASHER
BIG TOM COVINGTON
Dean Raymond
George Farren
HARRISON FORD
H. B. KOCH
DELIA TROMBLY
Marion May
Pardoe Woodman
Mary Glyme
Ruby Miller
Lionel D'Aragon
Re Judd Green
Ralph Forster
Richard Crawford
Bess Howard
Tom Weldon
John Sterrett
Andre Castignae
Irma Earle
Ernest Evers
Madge Kearns
Thomas Magrath
Ben L. Taggart
Lila Barclay
Della Connor
Aline Coughlin
Alice Owen
Edna Dupre
Mrs. C. Jay Williams
Sidney Vaughn
E. C. Taylor
Tabby
DORRIS BAKER
OTTO CYTRON
REX DE R
FRANK
NEAL HAR
Johnny Doyle
Billy Potter
Rex de Bosselli
VAN SUYDAM SMITH
EUGENIA GILBERT
J. Thornton Baston
Edgar Washington Blue
Lillianne Leighton
De Sacia Mooers
Bill Patton
Joan Templeton
Ned Templeton
James Cartwright
Frank Forsythe
Grace
Clax
Larry
Hileen Marcy
Wanda Allen
Patria Channing
Donald Parr
James J. Cassady
Robin Macdougall
Tula Belle
Edwin E. Reed
Emma Lowry
Wm. J. Gross
Florence Anderson
Katherine Bianchi
Lyn Donelson
Chas. Ascot
Tom Corless
S. E. Popapovitch
Mary Kennedy
Eleanor Masters
Sam Blum
Pauline Stark
Jonah Frost
PHILLIP ELLIOTT
JOE WHALEY
"BULL" AMES
ED. STANLEY
Helen Holmes
KITTY MILES
GRACE CARLYLE
CHAS. GUNN
ALBERT MC QUARRIE
JOHN MARSHALL, SR.
Gene Autry
Betsy King Ross
Dorothy Christy
Lester (Smilcy) Burnett
William Moore
George Burton
Hal Boyer
Bruce Mitchell
Wally Wales
Don Wayson
Jay Wilsey
Edward Poil
HARRY KEENAN
GEORGE AHERN
MARK THORNE
MARGARET NICHOLS
ADOLPH MILLER
JOHN PRESCOTT
Louise Dopelan
James Cassidy
HELENE CHADWICK
RALPH MC COMAS
O. C. JACKSON
MILTON SIMS
DONALD KEETH
Thora Erickson
Daniel Kerston
Olaf Erickson
Afton Mineer
Parry Banks
Tom Hastings
Frank Foster Davis
Rhody Hathaway
Baby Zoe Lewis
Imy Forrest
Francis Hopper
Jacqueline Gadsdon
Katherine Murphy
Elinor Hancock
Mr. George Soule Spencer
Miss Charlotta Doti
Mr. Gaston Bell
Mr. Bartley Mc Cullum
Miss Eleanor Barry
Miss Ethel Clayton
Mr. Richard Morris
Mr. Walter C. Pritchard
Mr. Richard Wangemann
Mr. Robert Dunbar
Miss Ruth Bryan
Miss Lillie Leslie
William Collier
Armand Cortez
Jimmy Aubrey
Al Ballett
Moble Johnson
Em Humphrey
Sidney Cushing
Thomas Brooks
Monti Collins
Miss Roland
George Marion, Sr.
Bud Jaimison
Thelma Salter
CHRISTINE MAYO
OTIS HARLAN
F. Richard Worthington
Sidney Smith
C. Cummings
Chas. J. Le Moyne
Mignonne
Derris Dane
“Sake” Turner
Nick DeRuiz
Stanley Lowe
Teddy Sampson
Dolly Crute
Clytie Whitmore
Gerald Pring
Anita Fraser
Patsye DeForest
WILLIAM MARTIN
FLORA PARKER DEHAVEN
JACK LOTT
ED. HEARN
MARJORIE BLINN
JAMES CAREW
MARGARET HALSTAN
JOE MARTIN
Harrison Hyatt
Alicia Hyatt
Mrs. Hyatt
Mr. Hyatt
Maxwell Graham
Sherry Tansey
Rose La Rue
Ted Brook
Virginia Faire
Capt. Anderson
M. Moranti
Sojin Kamiyama
Mrs. Wong Wing
Jim Morely
Evelyn Littlepage
Jonathan Parker
Lee Morris
George Nicholls
Adolphe Lestina
Dorothy Forrest
Elbert Santley
Cecile Forrest
Hubert Forrest
Anna Nilsson
Wilmuth Merkyl
Rose Coghlan
Thos. Jefferson
Chas. J. LeMoyne
Helen Gilmore
Lotta Kruze
Princess Ibrahim Hassan
Wm. Quinn
H. E. Canfield
Fred Eckart
Betty
Cora Lambert
Tom Mackay
Elsie Tarron
Dick Howard
Rebore Leonard
Mr. Hickman
D. Vinard
Arthur Graham
Charlene Aber
Minniela Aber
Anders Randolf
Bellie Farran
Cora Linton
Mae Bush
Sidney Bracy
Irene Wallace
William Beehtel
Mrs. William Beehtel
Jack Renault
Tracy
Billy Bower
James Leveing
Kate Kilgour
Richard Dodd
Etienne Pickerone
Gertrude Maloney
Gilbert Douglas
Leslie Casey
Gordon Dana
Delle Duncan
Olga Downs
Thomas A. Braidon
Billie Wilson
Charles W. French
Bhogwan Singh
Henry Harmon and W. H. Orlamond
Nazimova
A. E. Witting
Nina Cunard
Lydia Titus
Leonora Von Ottinger
Al De Ball
Bert LYTTELL
JACK LLOYD
Veora Daniels
Chas.K.French
William Frirbanks
Henry Herbert
Eddie Borden
Mabel Trummello
Annie Leonard
Allen Crellus
Allen Golyer
Bertie Leon
Susie Barringer
Gershom Cheney
A. D. Blake
Bose Evans
Dorothy Soderberg
Sidney Simpson
Bob Weston
Hank Forbes
Lucius Cassius
Palmer
Thomas Keeswald
Sarah Brundage
Lulu Glaser
Henry Norman
Tom Richards
Adila Comer
William Sloan
Hudson Liston
E. Cooper-Willis
Jas. Levering
Warren Rodgers
George Periolkat
Raymond Keane
Harry Burkhardt
Thelma Parker
Florence Deschon
NANCE O'NEIL
Reta Brenner
Julian Forbes
Mrs. Forbes
Mrs. Coombes
Mr. Brenner
Isobel Elsom
Mary Forbes
James Lindsay
Ivan Sampson
Mayme Gehrue
Hope Gordon
Jimmy Burton
Charles Henderson
Ellen Anderson
Herbert Stanley
Dean Griswold
Jean
Herbert Williamson
Dick Allen
Smoke Gublen
Bart Stevens
Letty Stevens
Cayuse Yates
His Gang
H. Chambers
Jean Gaussin
Florence K.Lee
Sylvia Mason
Jack Leslie
Fuller Mellish
Alice MacChesney
De Jalma West
John Steplling
Nolly Schaefer
Frank Thorne
Lillian Knight
J. BARNEY SHERRY
MARY THURMAN
CHARLES K. FRENCH
J. FARRELL MAC DONALD
Joseph Dailey
Lewis R. Wolheim
Mrs. Lettie Ford
Jack Norton
Mary Norton
John Blake
Helen Blake
Lombo
Charles E. Reeves
Billy Eugene
Valentina Zemina
Frank King
Belle Adair
Joseph Daly
Mrs. Slattery
Wallace Clark
Marie Weirman
Jerome Patrick
Maggie H. Fisher
Gus Erdman
Nana King
Arthur Tavares
Richard Talmadge
Patrick Harmon
Jonas Winthrop
Dan Thomas
Clyde Harven
Conway, secret service man
Bud, the waif
Louis Lester
Miss Christy
Edward Caxen
Mary Keane
Jim Canby
Bill Cody
Mark V. Wright
NAZIMOVA
Amy Veness
Ethelbert Knott
Elsie LaBergere
Allan Halubar
Carlton King (Harry Gripp)
John Perriton
Nora MacDermott
Harry O'Case
Dorothy Dee
Clarence Keyes
Marie Duquesne
Gustave Von Seyffertitz
William Humphrey
Erwin Connolly
Curtiss Cooksey
William Curran
Edward Mack
C. H. Geldart
Helen Stone
Bessie Lee
Ed Murphy
MARION DAVIES
Boyce Combe
W. W. Bitner
Pedra de Cordoba
Douglas MacPherson
Charles Coghl
J. P. Laffey
Ned Burton
Yvonne Day
Phillipe de Lacy
Helene D'Algy
Lionel Brahm
Bill Cameron
Madge Lee
Joe Thanlee
Walt Thanlee
Ralph Lucas
Sadie Lucas
Dorothy Woods
Ida Tonbrook
HAYDEN STEVENSON
SAM J. RYAN
CHARLIE ASCOTT
SAM McVEY
HELEN TOMBS
BRIAN DARLEY
Guide Colucci
Gordon Griffin
Fred Woodward
Olive Hembrough
Charles Fowler
Rose Norris
Mrs Henry Lamritzen
Mr. Valdemar Psilander
Mrs. Fritz-Petersen
W.M. WELLS
AGNES VERNON
CHARLES GIBLYN
JACK DILLON
WILLIS MARKS
Betty Overton
Joan Lawton
Hubert Richmond
James Agar
Mark Lawton
Mrs. Lawton
Peter Hoskins
Dr. Michaelson
Ralph Foster
Gordon Edwards
Arthur Williams
Richard Hatton
Elias Bullock
Raymond Thompson
May Cruze
Scott Beale
Zilth Borrella
Gilbert Elz
Mary DeWolff
Kempton E. Greene
Earl Western
Nancy Barrington
Ruth M. Connist
Marceline Day
Harry Rytings
Floyd France
Elliot Dexter
Eloise Goodale
OLGA GREY
GORDON RUSSELL
LOUIS COTA
DEMETRIUS MITSORIS
Don Baker
Claude Fleming
Billie Haskins
MISS VALENTINE GRANT
Jan Bokak
Victor McLaglen
Gordon Russell
Bryant
William J. Irving
Alice Nelson
Edward Carey
Ernest Murray
JOHNNY ARTHUR
CLYDE COOK
Billy Kent Shaeffer
Herbert Lingley
Rundle Arton
Jameson Thomas
Dacia
Dora Lewis
H. Stanley
Henry Aird
Sue Carol
Russell Powell
Harry Jones
LEE RUSSELL
JEFF SMITH
ROSE BUTLER
JOE BUTLER
William Shea
Joe Smiley
Gilbert Rooney
Millicent Martin
Mme. Josette Andriot
William L. Hinckley
Edward Roseman
Laurie Mackin
Florence Moore
George Morrell
LUCILLE HUTTON
SYDNEY AYRES
Arnold Gray
Majel Coleman
George Hall
Frank Green
Harry Earles
A. E. Warren
Frances Grant
J. W. Jenkins
Mary Cullen
Jim Fowler
Tim Cullen
John Marmakduke
John Coyle
Harry D. Carey
Jack Connelly
Andree Lafayette
Gordon Mullen
Max Constant
Robert De Vilbiss
Edna Pendleton
Bert Bus
Elsie J. Wilson
Sidney L. Mason
Anna Q. Nillson
Hershall Mayall
Jos. Swickard
William Courtley, Jr.
Robert Clugston
Al Thomas
Miss Iva Shepard
little Miriam Battista
G. Davidson Clark
Alice P. Clark
Edwin Chapman
Fred F. ELLis
Adrian J. Morgan
James Smiley
James O'Neill
Theo. Burkart
Charles T. Vincent
John Beveridge
Elsie Maison
Dandy Bowen
Ruth Burns
Victoria Danforth
Jimmy Weaver
John Collins
Jacques Marbot
Wm. Zoltz
Oleo Madison
Hylda Sloman
Virginia Brown
Frances Kaye
Albert M. Hackett
May Kitson
Frederick Esmelton
Rita Spear
Enrico Caruso
Robert Bombardi
Carolina White
Joseph Ricciardi
A. G. Corbelle
Bruno Zirato
Master Wm. Bray
John Wayne
Elizabeth Wayne
Frank Wayne
Lena Lorraine
Herbert Delmore
Dorcas Mathews
Mrs.Wallace Reid
Rocklifie Fellows
Laska Winters
Chas"Buddy" Post
Bladys Brockwell
LIGE CONLEY
Marian Harlan
HAYFORD HOBBS
Regina Badet
Edwn. Brown
Carol Cushman
GEORGE FARRELLY
Nancy Chase
Rex
Jane Wright
John Todd
Miss Haldiman
Miss Fuller
Norine Lawton
Christopher Gibbons
Count Bonzi
Henry Calkins
Mrs. Calkins
Drake
Horton
Margery Drake
Boyd Steele
JANE KECKLEY
JOHN BROWNELL
FRANK FANNING
Jennie Wetherby
Jimmy Wetherby
Herman Krauss
William Wellesley
Margaret Nichols
Joyce Moore
Eunice Murdock
Al Edmunston
Robert Fraser
David Hartford
Milliecent Fisher
Geo. Hernandez
Minnie Provost
Roy Diem
Lucille Young
R.Henry Grey
F.H.Gibson Gowland
Wm.Marshall
Bruce Smith
Capt.J.E.Nicholson
Joe Mead
Pete Larkins
Ned Donnelly
Lillie Leslie
Joseph Richmond
Constance Elliot
Keith Elliot
Butler Hayes
Ruby de Sensora
Maurice Duval
Edyth Chapman
Charlotte Woods
Terring
John Miltan
J. C. Fowler
Walter Rodgers
John Webb Dillion
Lewis Harvey
Kala Pasha
Marjorie Rambeau
T. Jerome Lawlor
Anne Sutherland
Nadia Gary
Mayward Mack
Anne Trevor
Arthur Trevor
Philip Sayre
William Maitland
C. Wood Ayers
Wilbur Ayres
Mrs. Sidney Drew
Gus Weinberg
William T. Carleton
Duane Lovett
Malcolm Leroy
Dan Hargreaves
Theodor Von Eltz
Jeanne Morgan
D. Witt Jennings
C. va. Williams
Mme. PETROVA
Violet Reed
Edward James
Lucille Younge
Alva D. Blake
Edward J. Peil
Howard Cooley
Brenda Bond
John Hamilton
Harlen Knight
Pen Wilson
Lillian Ardell
Silas Bragg
Margaret Rothe
Edwin De Wolff, Jr.
Charley King
Joe Gerard
Eve Dorrington
Harry Garrity
Albert Cody
Raye Dean
Gordon Ash
Leonard Mudie
George Spink
FRED GAMBLE
HARRY NOLAN
Elwyn Harvey
Joseph Gonyea
Ramsay Wallace
Sam Crane
Joseph Smitey
Grace Pike
Red Lennox
Al Heuston
Barbara Starr
Rileen Percy
Harry Caey
Bessie Arnold
Cliff Buckley
Wm. T. Carleton
Frank Darro
Alec B Francis
WALTER HATFIELD
LAFAYETTE M'KEE
Marion Barney
Henry Hebert
Clio Ayres
George Lessey
Charley Jackson
Jack Ridgway
I de Castro
Thos. Comerford
JEAN OLIVER
Gordon Grant
William De Vanll
Carl Gerrard
Robert Newton
Vera Redmond
Thomas Nevins
Inez Tremain
Dick Graham
Sallie Stanton
James Redmond
Arthur Botts
Gene Gauntier
Jack J. Clark
Van Dyke Sheldom
Marion Harlan
Wm. Worthington
Beatrice Morgan
Eleanor Berry
Chandice Keim
Aida Dale
Mrs. Vallois Erskine
Edward Carle
Hayden Stevenson
Kebel Trunnelle
Eva Loring
Lydia Yamons Titus
Clarence Geldert
Daniel Pennell
John Sunderland
Carl Von Schiller
Chas. Perley
PAUL DOUCET
NED BURTON
MABEL BALLIN
Carl Winterhoff
Chas. Haefli
Leopie Pimlath
Charles K. Wynn
Pat O'Leary
Paul Blais
Harry Lincoln) (Julian Reed)
Betty Austin
Leila Mead
Warren Wade
Katherine Griiffith
CLIVE BROOK
Virginia Ainsworth
PHILLIP D. EATON
LILLIAN WALKER
DONALD HALL
JOE HALPIN
RICHARD LESLIE
HATTIE DeLARA
MAE GREENE
DONALD MacBRIDE
Edith Lyle
Jane Miskinin
Max Barwin
Parks Jones
JAMES MORRISON
GEORGE COOPER
DOROTHY KELLY
VIOLET DAVIS
Josephine Dunn
Iris Gray
Robert Mace
Cherry Clark
Dirk McGraw
Jessie E. Terry
Katharine Macdonald
Sam Ryan
Red Wade
Sally Rogers
George Wilson
HOE CAREY
Lem B. Parker
William Hutchison
Bob Leroy
Jack Leroy
Amy Brandon-Thomas
Brian O'Brien
EDDIE GRIBBON
EDITH YORKE
GEORGIE STONE
JAMES McELHERN
Margaret Lard
John Manners
Adelqui Millar
Elissa Landi
Jim Hazen
Ed Larned
Ed Larned's wife
Will Sheerer
Echo Delane
Conrad Veidt
Erma Morena
Paul Richter
Lyda de Putti
Berhard Goetzke
Olaf Fons
Edwin Brown
Jos. J. Dowling
Jos. McManus
Joseph Rae
PAMELIA PALMER
LILLIAN WORTH
ROSE CADE
GERTRUDE CLAIRE
BETTY FRANCISCO
BRUCE WELLINGTON
DONALD MACDONALD
Mr. Cruze
Margaret Russell
Tiny Sanford
Gladys Gillen
Elinor Leslie
Milt Fahrney
Orrin Johnson
Marion Lydston
Robert Connessa
Isabel Lamon
Dorthy Bernard
Lillian Hall
Florence Flinn
George Kelson
Conrad Nager
Lynn Hammond
H.E. Herbert
Jerry Trimble
Ted Bradley
Myone Madrigal
Cyrus Bradley
Lily Everson
Gus Wimple
Pop Mahone
Micky Dennis Mahone
William Lowery
Violet La Plante
Shorty Hendrix
True Boardman
M. Duquesne (of the Vaudeville)
M. Manzoni (of the Vaudeville)
Mlle. Barchage (of the Opera)
Tsuru Aoki
Gina Palerme
Cady Winter
Felix Ford
Cora Walker
Robert Ames
Charles Post
Mikhall Vavitch
May Foster
Frankie Bailey
ROBERT ANDERSEN
DIXIE LAMONT
Thelma Daniels
J. Emmett Beck
W. P. Carleton
Helèn Lynch
Frank Bond
Richard Blake
Alma Lane
Reginald Trevor
Mr. Ruggles
Mrs. Ruggles
Mr. Clinton
Jane Reid
MISS REGINA BADET
Joe Green
Grace McGuire
Mike McGuire
BOSTON BLACKIE
LILLIAN WEST
ROBT. MELCHOIR
MICHAEL DELANO
FRED KELSEY
O.F. Hoffman
Blanche Bates
E. A. Warren
Master George Pickel
Harry Beaumont, Richard Neill
Wm. Blaiddell
Douglas Stanbury
Maria Gambarelli
Carmen Deleres
Jean Jacques Barbille
George Massen
Sebastian Deleres
Carmen
Mme. Langleis
Gerard Fynes
Edward Martindell
Frances Gordon
AL JOLSON
Bobbie Gordon
Cantor Rosenblatt
Bob Cain
Florence Beresford
Edith Ellwood
Ethel Lynne
GEORGE M. COHAN
Elda Furry
C. Warren Cook
Furnell Pratt
Eric Hudson
Carlton Macy
Jimmy Austin
Paul Brant
Henry Grady
Janet Davley
Robert Willard
Lenore Peacock
WALTER HIER
Yola D’Avril
Vaul Paul
Frances Howard
Gunboat Smith
Jimmy King
"Buck" Lowry
Poppy Saunders
ANDREW J. HUGHES
HELEN
MAE BUSH
ERICH VON STROHEIM
DALE FULLER
AL. EDMUNDSSEN
CAESARE GRAVINA
MALVINE POLO
LOUIS K. WEBB
MRS. KENT
C.J. ALLEN
EDW. REINACH
Sidney Ainsworth
Nancy Winston
Lydia Dalzell
Billy Garwood
Hal DeForest
W. T. Carlton
NICK DUNAEW
GYPSY HART
WILLIAM DYER
DOROTHY BARRETT
MILLARD K. WILSON
WEDGWOOD NOWELL
Harry Langdon
Bob Morley
Johnnie
Mrs. Morley
Jack Morgan
Virginia
Hardie Kirkland
McKenzie Twins
Hamad Thomas Santschi
Allan Deane
Naila Marian Warner
FATTY ARBUCKLE
Millie Malone
David Hepner
Sally Parker
Terry McNeil
Bill Hargus
Hank Robbins
Jim Parker
Terry McNeill
MARTHA GORHAM
WESTIE PHILLIPS
HARRY ARNOLD
SILAS GORHAM
JOHN PHILLIPS
MARY PHILLIPS
Willie Marks
Charles Brinley
Mr. Wadsworth
Nancy Sweet
John Darkcloud
Joe Flores
Elsie Ford
Rhea Haimes
RALPH MCCOMAS
CHAS. HAEFELI
Lillian Sylvester
THOMAS SANTSCI
Dave Winter
Eugene Palette
Jim Barley
Sam Appel
Clarice Sethyne
Lydia Yeamana Titus
Bud Sterling
Elise Collins
BILLY DOOLEY
Ruth Perrine
Henry Ainsley
Marjorie Lowery
Robt. Marvin
MALCOLM MCGREGOR
William Wads
“Kewpie” Morgan
H. A. Morgan
LENA HELMSTAEDTER
Lylillian Leighton
Ian Keough
Fred Ardath
Babe Nathan
Lou Bolton
Robt. McKenzie
Dolores Valdez
Dan Stone
Manuel Ortego
Nina Romano
Arnold Meloyin
Alida Newman
Nelson Ramsay
Wallace Bosco
Drelincourt Odlum
Winifred Sadler
James Alden
Clifton Brophy
John Mackin
Robert Schnable
Maud Hosford
Marie Temper
Clariette Anthony
Frank de Vernon
Mortimer Martini
Harold Hallacher
Karl von Stroheim
John Nicholson
Thea Talbott
George Arvine
Joseph Roberts
Jack Dempsey
Bertie Johns
John Fox
ANNIE LEIGH
Earle Courtney
Major James Courtney
Sadie Jones
Henry Ainsworth
Len Peters
Mrs. Leigh
William Jenkins
Ethel Ainsworth
Ella Burt
Paul Roubais
Dorothy G. Cumming
Lionel Braham
RUTH WEST
Jeremy West
Izeth Monro
Herbert Ross
Mrs. Marcia Vanderhold
Henri Wolvert
Ethel Hallor
Flore Revallies
Escamillo Fernandez
Gloria Goodwin
Mr. Duquesne
Mr. Paglieri
Mr. Maupre
Mlle. Renee Sylvaire, " de la Renaissance
JACK FURTH
JANE ROSS
MANUEL LOPEZ
JOSE FERNANZ
Cleo Ridgeley
Parker McConnell
Charlotte Burto
David Lithgoe
Em. Tedmarsh
Wm. Bertram, Wm. Tedmarsh
Geo. Ulrich
Richard Mason
Lester Caneo
Maizie Duncan
Nigel de Bruillier
VirginiaVance
Jim Dawson
John Craig
Mary Ellen Anderson
Stuffy Shade
Irene Ryan
Virginia Fry
C. Ogden
Frank L. Hemphill
Peggy O'Neil
Otis Stantz
Ed Lewis
Bert Barnett
Don Miller
Fred Weber
Laurence Grant
Clive Tell
Mabel Wright
Frank Farrington
P. Reybo
W. J. Gross
May Mc Avoy
L. C. Schuman
"Buster" Emmons
E. N. Wallick
Rev. Jerold Roper
Jane Roper
Meg Fortell
Jacques Fortell
Lloyd Perry
Madelein Fost
H. E. Thompson
Gwendoline
Albert Howson
Edward (Hoot) Gibson
Jack Pratt
Bob Kostman
Lefty Flynn
Tina Jones
Eileen Cotty
Elsie Bartlett
Audrey Squires
JOE KING
VIVIAN REED
FRED HEARN
DORIS REED
VIOLA ALBERTI
Dally Smith
Donald Crisp
Stella De Lanti
Juliette Belanger
John Elliott
Clara Haskell
Fred Wal
Harry Hold
J. A. Fury
Jean Sothern
Leo Delaney
Wm. O’Neill
Ina Brooks and George Henry Trader
BESS FLOWERS
THEODORE VON ELTZ
GENE STRATTON
JOHN FOX, Jr.
Henry Guy Carlton
Leon Dadmun
Hal Clarendon
H. H. Pattee
Jeanne-Marie Renee Adoree
Roger Audemard Gardner
Andre Audemard
Wm. Lowery
MARY GARDEN
HAMILTON REVELLE
ANDERS RANDOLPH
HASSAN MUSSALLI
HENRY PETTIBONE
ROBERTA BELLINGER
Fred Turner
Robby Kelso
LARS LARSON
JOHN THOMAS
IRENE BLACKWELL
COLLETTE FORBES
MADGE BELLAMY
RAYMOND HICKEY
WILLIAM CONKLIN
LULU WARRENTON
HENRY HUBERT
Warren Ellis
Bert Starkey
Peggy Prevost
Claire Du Bray
MERTA STERLING
JACK CONNOLLY
Marjorie Marcel
Jack Earl
Irving Lipner
Anita Frane
Irene Simpson-Bates
John Norton
Courtenay Urquhart
Victoria Vanning
Harriet Ross
Lucile Carney
Mary Navaro
Henry Lee
May Ward
Ed. F. Roseman
Harold J. Jarrett
Agnes Mark
Geo. Henry
Daisy Belmore
Lindsay Hall
L. R. Wolheim
Buckley Starkey
Luella Maxime
T. V. Henderson
Dixie Carr
Valda Valkyrien
Grace Stevens
Ezra Walck
Hubert Barrington
Patrick Foy
Dave Kirby
Ed Phillips
HENRY VIBART
JOYCE CAREY
JEFF BARLOW
NELSON RAMSEY
EDITH CRAIG
LANGHORNE BURTON
Helen Lee Worthing
John Marvin
Elizabeth Marvin
Anita Pan
Lee Kinney
Jessie Lewis
Paul Capellani
Barbara Gilroy
Eddie Young
EDITH SHAYNE
EARL SCHENCK
THOMAS FINDLAY
Chester Stanley
Florence Billings/Margaret Linden
Arda La Croix
Geo. De Carlton
Robert Gibbs
Ella Halt
Burton C. Law
Thomas McGuire
Edward Jobson
Rosa Morini
Alec B.Francis
J.Lindsey Hall
Fred. W. Huntley
George Gaffney
Lillian Clark
George Bliss
Forest Joyner
George Hartzell
Edward Ellis
Alma Hanlon
Togo Yama
James Wang
Thomas Haignan
Nabel Van Buren
Maya Koese
Zuth Venick
ed cody
Polly Vann
Frank Honda
Zoe Durea
Jane Cowl
Orme Caldara
Harry Springer
Harry Stephenson
Helen Blair
Edmond Lowe
Mrs. Edith McAlpin
FRED FULLER
ALICE LINDSEY
Cleo Ridgely
Winifred Edwards
Chas. Force
H. O'Dell
William Farris
Morris Cytron
Jessalyn Van Trump, Charlotte Burton
Robert Connness
Henry Leoni
Beaves Eason
Miss Helen Ware
Billie Recvcs
Mack Smiley Francis Joyner
TOM NORTON
WALLACE ELDER
EDWARD ELDER
EUNICE BAILY
MRS. NORTON
Miss Leah Baird
Mr. Don Cameron
Mr. Ellis
Miss Leila Blow Gray
Mr. Van Dyke Brooke
FREDERICK HAND
MRS. A. C. MARSTON
CHARLOTTE STEVENS
W. F. Canfield
Fred T. Jones
PAUL TREVOR
MARY WILTON
VIOLET TREVOR
JOHN BOWLING
Ferdinand Galvez
MARTIN KELLY
Bobb Dunn
Frank Butler
Mr. Foxe
Miss Clifton
Hal Reid
Mrs. Turner
Miss Richards
R. E. Milash
Harry Rattenburg
Sidney D. Albrook
Evelyn Nelson
Norval McGregor
Peggy Blackwood
Wm. Carroll
Bill White
Jim Welsh
Valentine Grant
P. H. O'Malley
Arthur G. Lee
Robey Rivers
Laurene Santley
Charles McConnell
Tom Terriss
Alice Morrison
Ben Rothwell
W. Standing
A. Shirley
Jen Morrison
George Berung
FRED GILMAN
Francis Newberg
Ethyl Davis
Boy Watson
William Sadler
Edward O’Connor
Leola McLean
Gordon Murray
H. W. Wells
Jane Manners
Tom Dempsey
E. N. Walleck
H. S. Griffith
Thomas G. Lingham
V. O. Whitehead
Harry Handworth
William A. Williams
Timothy Grogan
Gladys Garlock
Samuel Carlock
Henry Minor
Pa Shultz
Ma Shultz
Heinie
Jakie
Sadie Midgley
Rita Bard
Gertie Farron
LOUISE SYDMETH
GEORGE LESSEY
AUGUSTUS PHILLIPS
ERNIE SHIELDS
ED BROOKS
HARRY DEPPS
Otto Kruger
John Sharkey
Conradi
Ruth Whitman
Paul Horton
Dan Bulger
Guy Hatherton
Henri Rastraeli
Léna Willme
Vic. Collins
Hyman Cohen
Timothy Clancey
Marian Cohen
Molly Clancey
Lena Cohen
Tom Clancey
Molly Murphy
Barbara Conley
P. L. Pembroke
Anton Huber
Diana Kane
Harold Foshey
Bob Slater
Margaret Morris
Geoffreys Talbert
Gene Dumar
Gene Gray
William
Lillian Devers
John Johnson
Nathilda Baring
Benjamin S. Mears
Gretchen Wilke
Zoe Lewis
Tom O’Brien
Betty Morrissey
James T. Kelly
Margie Reiger
Jack Pollard
J.P. Hogan
Clarence H.Wilson
Robert E.Homans
Lottie Briacoe
Ed Mc Laughlin
Al Edmundston
Edwin Mc Laughlin
W. P. Hunt
Robert McKnight
Roscoe Karnes
Reichert
William Pepper
Otto Nobetter
Bob Van Dyke
Park Jones
GEORGE BICKEL
HARRY WATSON
Martin Regan
Willis Reed
Florence Morrison
Rowland Lee
Mrs. Dunmire
Colton White
SYD" CHAPLIN
Kathleen Calhoun
Charles F. Reisner
MARION LEONARD
LAURA LAPLANTE
Elfie Fay
Dr. Bruce Kane
Richard Kane
Ethel Radyard
G. Griffith
TOM SANTSCHI
CARL MILLER
EDNA PURVIANCE
JACK COOGAN
CHARLES CHAPLIN
TOM WILSON
Dorothy Eliason
W. Greenwood
L. Hart
Ivan Chrystie
Thomas Santachi
Dickey Brandon
David Kirby
Virginia Norden
Lucille Clayton
Gwen Williams
J. De Rosa
Charles Leonard
Zenadie Williams
Ben Turbett
Mabel Dwight, Maxine Brown, Low Gorey, Florence Stover
John Bunny
Nan Harden
Brock
Dynamite Dan
Andy
MARY O'BRIEN
Ernest Randal
Thomas Cameron
MARIE PREVOST
Blanche Ring
George Currie
Janis Clayton
Sally Clayton
Martha Clayton
Steven Saunders
Bad Gordon
Douglas Redmond
Mrs. L. Faure
Chas. Sutton
Siegfried Shuls
Ricci
Udina
Signora de Leonardis
G. Cattaneo
Carodenudo
Visca
Pasquali
Wilda Bennett
Steve Baird
Mike Reardon
John H. Tyler
Jackson Ives
Grace Tyler
Jas. R. Morgan
James Yorke
Mrs. Charles Craig
Medea Radzina
George Calliga
Douglas Gilmore
George Waggoner
Nola Luxford
Pamela Billings
Bill Billings
Glenn Kingdom
Oliver Holbrook
Carolyn Carter
Gwen Barker
Muriel Vane
John Holbrook
Robert Mills
"Wild Ben" Clark
Mrs. Brewer
Aunt Libby
MARY FULLER
HARRY EYTINGE
JOHN STURGEON
George R. Raymond
Leonre Peacock
Sid Saylor
CAMILLE ASTOR
HARRY HADFIELD
Mack V. Wright
Albert J. Smith
Paul Watlers
Walter Fitzroy
Bettie Riggs
William O’Neil
Al. Harris
Anthony Moreland
Veola Harty
FRANK KEENAN
Barry O'Neore
Marie La Marma
Claude Berkeley
Christiane Lewis
Barbara Litherage
Rosalind Joy
Jack James
Spring Gilbert
Victor King
Mystery Man
Mrs. Strang
Rosetta Duncan
Vivian Duncan
Myrtle Ferguson
Nils Asther
ROBERT GRANGER
LAURA HOPE CREWS
ROBERT HAROLD GRANGER
RICHARD MORRIS
CLEO RIDGELY
Grace Thompson
Fritz Wagner
Frank Longacre
Ethelmary Oakland
Douglas Gerard
Matt. Moore
Tom Lehmann
Walter Marshall
Raymond H. Kee
William Pables
Joe Sinkins
Howard Farrell
Oswald Staunton
MARK FENTON
DAN LEIGHTON
L. C. SHUMWAY
NELLIE ALLEN
George Gowan
Oliver Harding
MAX LINDER
Frank Cooke
Catherine Rankin
Charles Metzetti
Clarence Werpz
Fred Cavens
Jimmy Dugan
Anita Muldoon
W. Marks
Ian Paulson
Margaret O'Meara
Morgan Thorpe
Mrs. Robert Conness
Sydney DeGrey
John Toughey
John Barton
Lee Erroll
Ed Myers
LILLIAN MARSHALL
Billy Reeves
Laurence Fisher
J.Gunnis Davis
Tom London
J.L.Johnston
Anne M.Wilson
John T.Murray
Charles Anderson
Barney Fury
James O'Malley
Charles Ogles
G.W. Anson
Margaret McVade
Leonie Flugrath
Harry Mason
Eric Wayne
Isette Monroe
Frank Randell
Kenelm Foss
Cyril Percival
Margaret Brewster
John Millard
Young Bill Young
Nebo Slayter
Judge Wm. Dandridge
Lem Fyfer
Paul Paulus
Bill Gillis
Bud Osborn
Tom Grimes
WANDA HAWLEY
PEDRO DE CORDOBA
ARTHUR CULLEN
STEWART ROME
PERCY STANDING
HAMED EL GABREY
Wm. Bowmen
Wm. Morse
Herman Frank
James Hamilton
Will Move
Miss Spence
Joe Daily
Miss Courtney
Mollie O'Neill
Joe Lee
Gertrude Dallas
Roscoe (“Fatty”) Arbuckle
Josephine Stevens
Agnese Neilson
Hugh Bryant
Ward Simmons
Marjorie Welch
Frédéric Starr
Reeves Mason
FRANCISIA BILLINGTON
PAUL BYRON
MINA JEFFREYS
GILMORE HAMMOND
MRS. JAY HUNT
HECTOR V. SARNO
W. F. MUSGRAVE
Henry Barrow
Clyde Hopkins
Ernest Torrance
Ed Jobson
Ann Cleman ce
Walter Wills
WILLIAM S. HART
LOUISE GLAIN
MARGERY WILSON
ROBERT McKIN
J.P. LOCKHART
Alfred Lunt
Eden Grey
STELLA BENTON
JACK FYFE
WALTER MONAHAN
CHARLIE BENTON
Darwin Kerr
Minnie Stanley
Ted Sullivan
Jerome Kennedy
Miriam Nésbitt
Siegfried Schults
Harry Lyons
Bynunsky Hyman
Charles Requa
E.J.Ratcliffe
Florence St.Leonard
Nellie Farran
May Hill
IRENE FENWICK
Camille Dalberg
Albert Andruss
Virginia Mendon
John Mendon
Einar Hanson
Andre Sarti
Arnold Kent
Baby Brock
John Stepton
Edward A. Hearn
Roselyn Lynn
Robert "Quick" Benton
Lassie Doone
Murdock Macquarie
Mme. Sarah Duhamel
M.P.Bertho
M.L.Bataille
John Barclay
Bud Chase
Harry Ham
W. L. Rodgers
Mrs. Jay Hunt
Loei Stewart
Marie Sasse
James J. Cerson
George Romaine
Maloolm MacGregor
Olive Borden
John Miljon
Charles "Buddy" Post
Evelyn Jennings
Bertram Russell
Bruce Burns
Hunch Henderson
Holmes
Vera Vernon
Frances Parks
John Kronje
Carl Kruger
Paul Kronje
Cyril Maude
Capt. Fred Lloyd
Lencre Peacock
Eithe Pierce
Billie Bennett
Vic Allen
ED VAN SANT
Marjorie Gay
Henry Newton
Edith Willis
ALICE TERRY
Helena D'Algy
Wilbur Higbie
Frances Hatton
James McElhern
Albeita Vaughn
Elliott Roth
Montegue Blue
Miss Rosemary Theby
DOROTHY PHILLIPS
WILLIAM BURRESS
JOS. GIRARD
KATHERINE KIRKWOOD
ALBERT ROSCOE
Gloria Mae
Sybil Sealey
Rosita McNullen
George S. Bliss
Ralph Emerson
Donald Stuart
Ruth Cherington
James Leonard
Bobby Nelson
Charles North
Mrs. Ford
Fannie Midgeley
Claire Dubray
Joseph Bell
Buddy Messenger and Molly Gordon
J. Barrows
Fay McKenzie
Louise Morgan
Donald Morgan
Agnes
Amelia
Ruch Renick
Genevive Blinn
Miss Gunn
MAY McAVOY
PAT O'MALLEY
Miss Billie West
Polly Marion
Red Warren
Howard Van Cleft
Truex
John Plymuth
Steve Larson
Muriel Latham
Jack Latham
JIM WESCOTT
STELLA DONOVAN
FREDERICK CAVENDISH
ENRIGHT
JOHN CAVENDISH
CELESTE
Alice Randolph
Al Edmundson
Billy Hopkins
Blanche Whiting
Harry De Peyster
Sonia Kerbs
Geo. Morgan
Doris Sawyer
Hilton Rosmer
Thelma Bruce Potter
Rutland Barrington
Sidney Lewis Ransom
R. H. Brooks
Lady Tree
BETTY LEE
MILES GASTON
JACK FAY
NICEL DE BRULLIER
HARRY RUSSEL
Chester Bennet
Jack Lyons
Alice Bratten
Tom Dickson
WM. PETERS
Sallie Crute
Fern Roberts
Ralph Hartley
Joe Ramsey
Jay Eaton
Ann Hastings
John MacKinnon
Slim Hoover
G. Norman Hammond
Ed. Lewis
Bert Bennet
Tom Miller
Mary Gardner
Margie Rieger
Eddie Fries
Ed. Armstrong
Mr. Newman
John Alstrom
Helen Dubois
Bonaventura Ibanez
William H. Powell
Frank Puglia
ANNIE DALY
ALICIA DALY
Michael Vavitch
Carolyn Dexter
Janet Fotheringay
John Arnold
Dicky Bannister
Maurice B. (Lefty) Flynn
W. S. Weatherwax
Ben Corbett
Frank Milburn
Joyce Bruce
Harold Mathews
Gertrude Selb
John Alden, Jr
Alfred Schmid
Teddie Gerard
Helen D’Algy
Jean Del Val
Raphael Bongini
William Betts
Edward Elkus
A. De Rosa
Evelyn Azzell
Marie Diller
DAVID CLARK
RANKIN PORTER
JERRY MATHERS
EMMELINE WARREN
HENRI PONLEUR
MRS. BILLY HARDWICK
FANNIE HARRISON
W. Reed
Eugene Borden
Bob Rhodes
Dan Crimmans
Meta Sterling
Henri Leone
Richard Garrick
Carl Dietz
LIANE DEMAREST
James Wilbur Scovill
Claude Drummond
Marie Adell
Floyd Buckley
AL W. FILSON
ENGENIE BESSERER
Charles Burbridge
Sid Bracy
Louis Leon Hall
Gustave Thomas
Florence Crawford
John Anders
Jim Small
JOE DE LA CRUZE
Laura Praether
Elda
Henry
NICODEMUS NOBBS
Zane Grey
Edward Gribbon
Ralph Yearsley
Bob Williamson
Robert Fleming
Alma Tell
Zola Talma
Cecel Humphreys
T. Haviland Hicks
Jack Merritt
Jane Wolfe
Dorothy Rosher
Lorenza Iazzarini
YVETTE MITCHELL
L. M. WELLS
Camilla Challenor
Lawford Davidson
peter Starling
Cameron Carr
Joan Morgan
Fred Starr
Alexander Gaden
Helen Holly
Chief Standing Bear
Sydney Lewis Ransom
Brenda Patrick
Barbara Conrad
Malcolm Keen
Fred Thompson
Albert Frisco
Georges Rigas
Jean Debriac
Joe Mauchin
Jeanne Verette
Roul Verette
Constable McKenzie
Mabel Trummelle
Yale Bemner
Robert Lawton
Homer Oldfield
W. T. Carleton
Fred Groves
Fred Volpé
Owen Nares
Fay Compton
Christine Silver
Lauri De Frece
Mrs. Macdona
Margaret Ardath
Robert Ogden
Patricia Landon
Erickson
Jane Jennings
Bobby Watson
Lea Penman
JOHNNY GOUGH
Buddy Roberts
Estelle Morgan
Ann Morgan
Kokua
Billy Jacobs
Emily Lowry
Charles Ruggles
Frazer Coulter
Charles Riegel
Raymond Lowney
DON BARCLAY
Frances Benedict
Roger Blakely
Art Somers
Grace Corliss
John Corliss
Aaron Rasp
JACK TEMPEST
Robert E. Green
MAY BOARDMAN
Billy Bettingen
Gabriel Barrato
Benedetto Barrato
Sir Donald Verney
M. Charles Krauss
M. Liabel
Mlle. Sylvaire
Lawrence Peyton
Chas. Brindley
PHILLIPS SMALLEY
EDWIN HEARN
PAULINE ASTER
MARY MAC LAREN
CECILIA MATTHEWS
AMBROSIA LEE
DON WHITNEY
CHARLOTTE WHITNEY
GEORGE WEBB
FRANKLIN WHITNEY
A. E. WITTING
FRANK McQUARRIE
LINCOLN STEDMAN
George Smith
Edmund Thompson
Samuel Griggs
Scot McHale
Katherine Bates
Harry Von Weter
Mrs. Coxen
Dorothy Cummings
Al Houston
Ray Childs
Miss Wilmarth
Jim Mason
Katherine Fischer
Virginia Harding
Abe Mundon
Sarah Conway
Abe Conway
George Meech
Forest Winant
R. A. Caven
Marvel Rea
Erle C. Kenton
Lola Maxam
Francois Dumas
Buck Jones
Charlotte Guest
Fred Steward
Tom Malloy
Bob Bernard
George Billways
Louise Joyce
Emil Collins
ANNICE PAISH
Edna Lawson
Michael Darcy
Vance Dunton
Dr. Rodney Paish
Cord
Michael Connors
The gardner
The gardner's wife
Dr. Dumbbell
Mrs. Elna Pom
Mr. Emil Helsengren
Mrs. Edith Buemann-Psilander
Mr. Aage Garde
Mr. Rich Christensen
Mr. T. B. Bøwmer
Kathlyn O'Connor
Mrs. J. M. Sullivan
Andie Clark
Violet Debichorie
Jemes Alling
Kathleen Myers Jane Winter
Nick De Ruiz
Mme D'Esterre
Nat Holson
Amos Broadstreet
Alice Day
Lucile Allen
Lou Gerey
Lenora Van Benschoten
Alice Gray
O. N. Hardy
George Berrel
Robert Smith
Evelyn Burns
Annette De Foe
Bonny Hill
Joe Roberts
Eddie Nelson
MARC MACDERMOTT
GLADYS HULETTE
GEORGE A. WRIGHT
BIGELOW COOPER
Maurice B. Flynn
C. M. Ackerman
Phil Robson
Loduski Young
GRACE DAVISON
MONTAGU LOVE
Maddie Irwin
Fred Worthington
Ben Withers
Eve Leslie
Adam Moore
Mabel Strickland
Eddie Delane
Doris Pringle
Jonathan Pringle
Lewis Edgard
J. Farrell Macdonald
Ferdinand Gottschalk
Roger Lytton
Ann Christy
Mrs. Fiske
Mrs. Westerley
Mrs. Austin Brown
Arthur Row
Mrs. G. M. Clarke
Philip Quin
Maurice Steuart
William Wirth
Vi
Ella Tarrant
Buddy Post
John Hobart
Bob Morris
Neeley Edwards
EDDIE GORDON
Alf Goulding
Dorris Lloyd
George Hackathorne
John Fox, Jr
John Heraman
Edwin Hubbell
Miles McCarthy
Baby Clemens
Lloyd Baxter
Betty Noon
Mickey Yule
Delia Bogard
Junior Johnson
Bobby Lloyd
Jim Manville
Hal Norton
Jake Woods
ROSIE LEE
JERRY BROOKS
DADDY LEE
TIMMY LEE
DAVE ELLIS
TOM MORSE
MURPHY
ROBERT SHELDON
DOLLY WILSON
FAN BAXTER
WILLARD THATCHER
MRS. SHELDON
ANDREW ROBSON
HENRY GODFREY
I.I. Mozukin
Mme. N. A. Lesienko
Helen Broneau
Joseph de la Cruz
Clark Coffey
Slim Hamlilton
Mr. Eason
Maude Emory
Edouard Raquello
Dick Benson
Linda Arvidson
Clara T. Bracey
Mrs. Hernandez
Edward Wade
Stella Adam
James Ford
Ruth Chalmers
M. Hatton
Johnnie Cook
Cecil Humphreys
Charles Hammond
Louise Grafton
S. B. Carrickson
Denis MacSwiney
Sidney Dalbrook
Gertrude Mudge
Peter Pan
Miss Mae Gaston
Raymond Russell
Miss Helen Wright
Genaro Spagnoli
Eugenio di Liguoro
Henrietta Floyd
Vadim Uraneff
Edwin Brady
Frances Warner
J. S. Stembridge
Cullen Tate
J. Russell Powell
GALE HENRY
ZASU PITTS
CHARLES HAEFFLI
Ed. Bradey
Frank Tokunaga
Helen Dumbar
Edwin Booth Tilton
Margaret Lee
Paul Knox, Jr.
Gail Henry
JACK MC HUGH
Dillo Lombardi
Valeria Creti
Lois Weber
Rex Downs
Phillips Smalleu
Myrtle Gonzales
Vicky Victoria Forde
Brodwitch Turner
Frank ("Fatty") Alexander
Jackie Coombs
VIRGINIA FAIRE
Mary Anderson
Tugh Thompson
Lew Harvey
Nick F. De Ruiz
Leela Lane
Eugenia Gilbert
Clarl Stockdale
Dorris Deano
Albert S. Lloyd
Amedee Rastrelli
Tom Mahoney
Walter Percival
MARGUERITE SNOW
Zella Call
J. W. Goldsworthy
Wilfred Roger
??????
J. Wallingford Speed
Larry Glass
M. B. Flynn
Frank Braidwood
Thornton Van Sant
Constance Johnson
Jill Woodward
Lingah Wing
PAUL BENTON
Jack Livingston
Hart Haxie
Fred Spencer
George Drew
Florence Auer
Clifton Webb
Wm. Ricciardi
Mike Rayle
Katherine Sullivan
Adelaide Elliott
Miss Dawson
Robert Carleton
Margory Manning
Jimmy Walker
Leonard
Reeves Bacon
Joe Sampson
Dolores Winthrop
Spencer Crosby
William "halfim"
Nellie Farron
Bill Hopkins
Richard Manslot
Joseph Howard Gordon
Alma May Kern
Duncan Gordon
Charles Rush
Edna Dietzel
Dave Don
Evelyn Selbe
Scott McKee
Jesse Devorska
Kalla Paseha
Matherine Griffith
Isabelle Vernon
Estelle Sprague
B. Hampden
Dave McCauley
B. Davenport
J. Furey
Alfred Paget
Thomas Delmar
Arizona Brady
Mrs. Winkle
Mrs. Skilligan
Nat. C. Goodwin
Paul Winthrop
Bill Hamilton
Mary Downing
Buck Wilson
"Skinflint" Bressler
Jim Downing
Ted Howland
Month Banks
Wm. Blaisdell
Bob Pretty
Dicky Weed
Jeff Barlow
Will Corrie
Vivian Gibson
E. Gibson
Rodney LaRocque
Kid Broad
H. Van Bausen
Helena D’Algy
Ed. Baker
Marbia Moore
Waallace Reid
Grace Bolton
Tom Williard
Rin-Tin-Tin, Jr.
Edwin Carewe
John Melody
Arthur Evers
Kitty Stevens
Jas. B. Weaver
Elora Braidwood
Bert Frank
Jan Stewart
Marie Percivale
IRENE VANBRUGH
DENNIS NEILSON TERRY
GLADYS COOPER
BEN WEBSTER
SIR JOHNSTON FORBES-ROBERTSON
C. M. LOWNE
NIGEL PLAYFAIR
LILLAH MCCARTHY
DION BOUCICAULT
GERALD DU MAURIER
DONALD CALTHROP
WINIFRED EMERY
H. B. IRVING
J. FISHER WHITE
LYALL SWETE
HELEN HAYE
MABEL RUSSELL
WEEDON GROSSMITH
MARY BROUGH
PHYLLIS HART
GERTRUDE ELLIOTT
LILIAN BRAITHWAITE
LOTTIE VENNE
STELLA CAMPBELL
VIOLA TREE
RENEE MAYER
FABIA DRAKE
JOAN BUCKMASTER
G. H. ROWSON
Al Jacoby
Bill Monroe
Jennie Anna Dodge
Jim Daly
L. D. Malony
Geo. Perry
Geo. Cummings
Joe Neary
Mr. Wesschusen
Max Linder
William Grogan
Ruth Warren
Camden
Ernest Butterworth
Mildred Harris Chaplin
Loyola O’Connor
Tom Blake, Jr.
Niles Welsh
Violet Axtell
Lillian Rossine
John Cumberland
Angela Warren
Marie Provost
Harriett Hammond
RAYMOND GRIFFITH
Nigel de Bruliere
Jacqueline Gadsen
Jerry Austin
George Drangold
JACK McILVAIN
EVE BALFOUR
W. BRANDON
THOS. H. MACDONALD
GEORGE FOLEY
JOAN MORGAN
THELMA GIDDENS
LILY SAXBY
Madaline Pardee
Daniel Gilfeather
Jas. Kirkwood
Robert Mack
Burton Law
Albert Pollet
Thos. Gray, M.D.
Harry Gray
Virginia Fordyce
Dolly Beal
Virlan Hesbitt
WM. WATERS
JAUN DE LA CRUZ
WILLIAM SHEER
FRITZI BRUNETTE
OGDEN CRANE
CHARLES DORIAN
KATHERINE WALLACE
FRANCES MURPHY
Buddy Mason
Wm. Gettinger
Charles Bryden
Hilda Wierum
ETHEL CLAYTON
Charles Morgan
SVEN JOHNSON
DOUGLAS GORDON
LAWYER JUDSON
JACK HARDY
Elizabeth Garrison
Blais MacLeod
Allan Herbert
Clem Judson
Milton Uhl
CHARLES FEEHAN
JACK F. McDONALD
F. O. GALVEZ
Mary Ward
Tobe Leggett
Un. Bertram
Tinifred Greenwood
El Coxen
Josephine Pitt
Art Atkins
Harry Gribbons
M. Blevins
J. Livingston
Isabelle Lamon
Adele Finks, Thomas Dwyer
Asthilde Baring
Gladys Cooper
Ivor Novello
Ellen Terry
Constance Collier
C. Aubrey Smith
Kathryn Carver
Wm. Norris
Percy Ames
Inella Gear
Wm. Davidson
Edward Douglas
Bardley Barker
Horace James
Ming-Ti
Frank W.Smith
Charles Tang
Virginia Tremont
Harold Lounsbury
Kenly Lounsbury
Bill Bronson
Mah Lung
Madge Kirkby
Alice Hastings
Marguerite Foss
SIDNEY DE GREY
HUBERT ROSCOE KARNS
WM. TURNER
Beatrice Bentley
Baby Marion
Etta Lee, Ming Young
Lawrence Underwood
Harry Watson, Jr.
Anzonetta Moore
Frank Weber
Matthew Betz
Mrs. A. F. Witting
Albert Caven
M. Walters
John Marsh
Frank Newbury
Mr. Fred Paul
Miss Agnes Glynne
George Ross
John Bates
Frank Hill
Scott Leslie
Mrs. Kraft
Arthur Trazeris
Thomas Walsh
WALLACE MAC DONALD
HUNTLY GORDON
Bert Marburgh
Louis d’Angelo
Delicia Romana
Col. Navarro
Franklym Farnum
LYNN REYNOLDS
ED CODY
Tim McCoy
Chief White Horse
Ann Forrest
William H. Woodworth
Auline Coughlin
Mrs. Bechtel
Leo Pearson
Herbert Newlinson
W. Oakman
Earl Hurd
Helen O'Neil
Willy Grosby
Helen Trent
Geo. Deneubourg
Stephen Lee
Billy jacobs
Miss Kibby
Millard K. Wilson
GLORIA SWANSON
Walter Goss
Robert Fischer
Chaplin
Dorothy Warshauer
Benny Corbett
Effie Ellsler
Corliss Palmer
Shirley Dorman
George Anderson
Lillian Allen
Kathleen Kerrigan
Lois Wood
Gertrude Neyland
Nelson Thorpe
IVOR MCFADDEN
MARION EMMONS
KATHERINE CAMBELL
ETHEL BROWNING
Alfred Wertz
Betty Hart
JOSE SUAREZ
E. Mazo
Frank Webb
Louise Fiske
Florence Shirlow
Violet Neitz
Mavm Kelso
Charles H. Prince
Diane Sorel
Malcolm Kent
Andrew De Clermont
Madame De Clermont
Edward Harding
Luisa
Jimmy
JOHN MACKINNON
Billy Engel
Miriam Hutchins
William A. Brady
Harley Knoles
Little Marie Gordon
Zula Claire
Sally O'Neil
Mary O'Brien
Buddy Fine
Gene Polar
George Romain
Franklin B. Coates
Karla Schramm
Donna Pepita Ramirez
Lewis Sterne
Mrs. Ellis
Harriett Notter
Bobby Murdock
Hugh Mosher
Red Walden
Sally
Jerry Zier
DEAL HENDRIE
Charles Richmond
Bob Mackenzie
Paul Kruger
Steve Hatton
Scott Turner
Warpee
Monty Garside
Mrs. McCarver
Vimie Burns
Andell Higgins
Harold Lynn
Norma Winslow
ETHEL SHANNON
Eddy Chanler
Fred Behrle
James O’Neill
Nell Shipman
W. H. Mullen
Isabel Berwin
Ed. M. Kimball
Otto Mathieson
Marthan Franklin
Nigel De Brulier
Tristan L'Hermite
Maud Muller
Conway Royle
Gail Harvey
Helen Terrane
Warren Terrane
Joseph Gerrard
Joseph Harrington
J.H.Gilmour
J.Webb Dillion
Reeves Eason, Jr.
Tex Ferris
Wm. Dunn
Chas. Sellon
Ethlyne Clair
Corinne Barker
Brenda Adams
Arthur Synott
Miriam Vale
Blake Stanley
Ed Stanley
Barton
Sarah Stanley
Jake DeWitt
Jim Vale
Jack Rance
Old Bill
Wm. Dowlin
Jim Moore
MICKEY BENNETT
Malcolm Sabastian
Vera Doria
Felicia Day
Rodney La Roque
Miss Edyna Davies
Miss Ada Nevil
Miss Agnes Everett
Edward A. Fetherston
Miss Jean Lamb
Joseph Latham
Emile Drain
Henry Fouche
Denise
Catherine Hubscher
BRUCE LAFNIGAN
Togo Yammamoto
Julia Wayne Gordon
ALICE BRADY
James L. Crane
David Montero
Mrs. Tony West
Carolyn Irwin
Roni Pursell
Dorothy Betts
Virginia Huppert
Russel McDermot
Molly Malcne
Gustav von Seyffertitz
Spec O'Donnell
A. L. Schaeffer
Monty O'Grady
Jack Lavine
Florence Rogan
Seessel Anne Johnson
Sylvia Bernard
Ralph Ince
Patrick Hartigan
Red Eagle
Jacques Suzanne
GERALDINE FARRAR
Henry Carvil
ROSALIND JOY
SPRING GILBERT
Edward Borman
Howard King
David Vaban
Harvey Ogden
William Ogden
Joe Dubois
Black Lynx
Jimmy Dickson
Betty Thompson
Col. Thompson
Virgie Foltz
Mary Glynne
Marjorie Hume
PERCY Standing
Isabel O’Madigan
Louise Derigney
C. B. MURPHY
Dionne Ellis
Thomas L. Brower
Barbara Moore
Allan Day
Dorothy Fitch
Marguerite Delamotte
Morris Hughes
Dorothy Preston
Oren Evans
Stid Butterfield
WILLIAM STOWELL
ROBERT ANDERSON
FRANK BRAIDWOOD
GEORGE HACKATHORN
MARGARET MANN
Pat O'MALLEY
William P. Carleton
Arthur H. Ashley
E. J. D'Varney
Lila Hayward Chester
E. M. Kimbell
Helen Delaine
Eddie Martin
Flora
Jack Delaine
Oscar Nye
William Musgrove
Betty Hatton
Henry F. Crane
Ann Darling
Rex McDougal
Frederick Raynham
Allen Jayes
Betty Campbell
Naida
Hugh Converse
Mrs. Pratt
Mildred Lee
John Hay Cossar
Macey Harlam
Harrison Cole
Gladys Applebe
Mare MacDermott
Horace Newman
Seedy Hobos
Bertram Grossby
O. E. Wilson
Kene Rogers
Ivan Falkenstein
Milton Weiss
Dal Goff
Martin Hall
Mary Kornman
C. Pitt Chatham
Arthur Bell
Beatrice Templeton
Clarence Johnson
Rodney La Rocque
Hazelle Coates
Donald Clayton
Marian Murray
Archie Lowndes
Mary Clare
Hayden Coffin
Adeline Coffin
Reggie Cosway
Allen H.
R.
CHARLOTTE MERRIAM
GRACE MARVIN
Miss Colleen Moore
Sydney Chaplin
HARRY MOREY
MARION TAYLOR
HENRIETTA GREELEY
FRANCES GARDENER
LOUIS WADE
COUNT RICHARD & TERRION
MRS. BURNS
DR. RAMSEY
MRS. GARDENER
MR. GARDENER
MARGUERITE COURTOT
EDMUND BREESE
WALTER MILLER
CLARA BOW
Jay Abbey
Gladys Juliette
Anne Clifford
BENJAMIN WILSON
RICHARD NEIL
Nan Christie
Clive Livingstone
Betty Livingstone
Robert W Jenks
Anna May Jackson
Richard W Jenks
Lois Lee
Bert Wilson
Walter Tennyson
Nellie Franzen
Lionel Felmore
S.J. Sanford
W.J. Ferguson
James Bradford
Ralph Martin
Helen Graham
Al W.Filson
DeWitt C. Jennings
M. Titus
William Wayne
Joseph Floris
Miss Fay Compton
Catherine Calvert
Stuart Kingsley
Marcus Moriarity
Bessie Brown
Louise M. Bates
M. Duquesne
M. Rosc
M. Mardor
MM. Madeline Grandjean
Mlle. Marise Dauvray
Mlle. Renee Sylvaire
Agnes Carlson
Milton Douglass
Dan Carlson
Carroll Nyo
Billy Scott
Mrs. Krudge
Hollins Anthrim
Phil Mason
Allan Garcia
Charles Hickman
A. E. Whiting
Ned Worworth
Lucy Donahue
Ralph Lee McCullough
Mathew Biddolph
Madga Lane
Princess Neola
FRANK MCINTYRE
Comtesse De Martimprey
Belle Rainey
Violet Hopson
Stewart Rome
Harry Buss
Harry Royston
Harry Gilbey
Chrissie White
Robert Dunlap
Daniel Higgins
Baby Lillian Wade
ROMUALD JOUBE
MR. SEVERIN-MARS
MME. MANCINI
MR. DESJARDIN
LITTLE ANGELE
Jack Rattenberry
Laura Oákley
Stella di Lanti
Rev. Neal Doug
Brocks Benedict
Charles O'Mailey
Maine Geary
Cissy Fitz-Gerald
Nan Ch
Beatrice
Robyn Ada
Bessie Ba
Barry Macollum
Jacqueline Allen
Corinne Lesser
EDDIE SONNERS
NAN HARDEN
MALCOLM SONNERS
JAMES GOLDEN
FREDERIC STARK
DUNN R. LUCE
Korrie Williamson
Helen P.
John
Jonathan Wise
Justin Haddon
Rachel Stetherill
T. Boggs Johns
George Nettleton
Maude Eburne
Florence Cole
Thomas J. Vanderholt
Edw. Burns
Breezy Eason
Jack Sahr
Kay Abbey
Edward Clark
Eduard Trebaol
Susan Grandaise
Brenton Marchville
George Treville
Grace Derval
W. H. Forestelle
Jeanne Eagels
Pauline Lord
Frank Craven
Dick Farragut
Ruth Small
Mr. Holmes
Jan Van Dullen
Jehan Daas
Baas Cogez
Marie Cogez
Alois Cogez
Baas Verhaecht (Landlord)
Dumpert Schimmelpennick
Vrow Schimmelpennick
The serving maid at Cogez
Herr Kiesslinger (Hardware Dealer)
Herr Brinker (Artist-Tutor)
Caretaker (At Cathedral)
"Teddy"
Julia Hanwell
Anthony Rayne
EILLES NORWOOD
HUBERT WILLIS
CLIFFORD HEATHERLEY
NORMA WHALLEY
Palmer Morrison
George Lassey
Art Walker
Ben Wilson Jr.
John Bowman
Monica Trant
William Waters
Bobby Bolder
Katherine Sohn
Katherine Van Buren
Virginia Feltz
HELEN URMY
EVELYN SELPIE
FRANK WHITSON
JAY BELASCO
EDDIE BROWN
William Quirk
Pearl Sindelar
Ada Charles
Frank Moulan
Denman Maley
Frances Samson
Maurice Flynn
William B. Davidson
Raymond Nye
Barbara Brower
Beth Van Dyke
Karl Silveira
Jack Tuden
Eugene Stone
Victor Hotel
Waldo Perry
Semple
HELEN HOLMES
James T. Galloway
Charles W. Sutton
William A. Bechtel
Baby Violet Axzell
Arthur Carew
Abraham Schwartz
Nan Peters
George Merrill
Nell Fenwick
Billy
Nellie Hartley
Louizetta Valentine
Edgar Murray, Jr.
Mrs. Wiggin
Lloyd Sedgwick
May White
Mizi Goodsadt
E. C. Roseman
Helen Marten
Robert Angel
Anne Cornial
Chas. A. Seldon
Robert Hale
Henrietta Watson
Frederick Groves
Hugh Croise
WILLIAM HOWARD
CLYDE BENSON
JANE WATSON
Fritzie Brunette
George Kleine
Donald Brian
Frank A. Connor
Florence Smythe
Ora Carewe
Ray Stewart
Leon Errol
Ray Haller
Capt. E.H. Calvert
Louise Baudet
Joan Beverley
Earl Foxe
Betty Pendleton
Robert Blair
Jack Pendleton
Stanley Gates
Mabel Montgomery
Getrude Selby
Rex Rosseili
Cladys Hullette
Ramon Randolph
Charles E. Ashley
Elizabeth Tinder
Charles W. Racey
GILBERTE BONHEUR
AARON WITT
EDWARD CRAIG
GEORGE CORNHILL
LUTHER RIPLEY
ANTHONY JAMES
Barbara Tennent
Mildred Bright
Miss Davis
Lamer Johnstone
J. Gumis Davis
Louis R. Greisel
John W. Dillion
Victor Mezetti
Mary Elizabeth Forbes
Anne Howell
Henry Beraman
Camille D’Arcy
Lucia Norman
Oliver Weston
Betty Peterson
Harry Neville
Ferd. Tidmarsh
Charlotte Shelby
Harry Ford
William Rausher
Mae De Metz
THOMAS J. CARRIGAN
Bob Nolan
Franz Molenar
Lucie Höflich
Lothar Koerner
Caroline Irwin
James Welsh
Jack C. Livingston
M.O.Penn
Eleanor Woodruff
Jack Roi
Boris Alexieff
John Milterne
Dulcie Cooper
Ben Johnson
Joseph Weber
Oliver Smith
Bennie Alexander
“Breezy” Eason
Ruth Golden
Billy Higgins
Martha Brown
Lily Philips
Ard Accord
Joe De La Cruz
HOWARD HALL
CLARENCE HERITAGE
Roy Byford
Joe Galbraith
Harry Von M
Harry Fischer
Jack Miller, Jr.
Charles E. McHugh
Bodil Rosing
Mary Page
Frederick Church
Jessica Page
EVELYN BRENT
Billy Lawrence
Tobias Smith
Chris Busby
Phil Small
May Orme
Sally Crutem
Harvey Clarke
E.E. Bolton
Lucille Y oung
Eleanor Parker
Ethel Terry
Harry Belden
Violet Talmadge
Melissa Fahrbach
Jack Lewis
William Danforth
Edwin Dennison
William Platt
Aima Bennett
Bill Horn
Hai Mathews
PHYLLIS DAREL
HOWARD FOLSAM
LOUIS DUTTON
ROBERT BRANDT
Murdoch MacQuarrie
John Rickson
Art. Artego
Noble Sissle
Eubie Blake
Ikie Ikestein
FORD STERLING
Guy Woodward
Mr. Denecke
Tallulah Bankhead
Alec. B. Fra
Brenda F.
Warburt. on Gan
Grace Hend
Ruth F
Jas. W. Girard
Gene Luneska
Elsie McLeod
Philip Hubbard
Louis Calhern
Samuel Niblach
J. C. O'Laughlin
Logan Paul
Albert Macklin
Malcom Gaines
John Spence
Ed. Silbur
James Crosby
Sallie Crosby
Tom Johnston
JOHN VANCE
AILEEN CALVERT
CHARLES KANE
Bert Westem
Miss Leona Ball
Lucy Peyton
Lillian Gonzalez
Louise Linn
William Ehfe
G. Backus
J. Flanigan
C. Charles
Betty Paterson
Gerard Grassby
H. Harroun
Miss E. Stone
L-Ko Fat Boy
Patricia Wolf
Forrest Seabury
James Brooks
Jean Dimar
ORRIN JOHNSON
HOPART COSTWORTH
CHAS. HICKMAN
Jimmy Rogers
Louis J. Durham
VIRGINIA BROWN FAIRE
George Cheeseborc
Paul Dennis
Hazel Howell
Harry Griffiths
Thomas A. Wise
Marion Summers
Gordon Barnes
Bess Meredyth
LAURA LA PLANTE
Arthur Osborne
Philippe de Lacy
J. M. Dunont
T. E. Duncan
Viola Smith
Bob Walton
Wm. Wallcott
Ruth Byran
Frank Backus
Alon Qahim
Douglas Sibola
Nestor
Mrs. Tanzy
ROBERT CONNESS
Olive Wright
William Henry
William Gould
Mary Coverdale
Clarice Stapleton
Louise Prussing
Reggie Hughes
Joey Clark
Maryon Aye
Eugene Burr
L. S. Reynolds
Pearl Elmore
ANITA CUMMINGS
CHARLES MURPHY
Earle Brunswick
Sue Balfour
Camilla Dalberg
Edwin Boring
Carlton Miller
Eleanor Middleton
John P. Wade
William Gregory
EDITH DE VALMASEDA
LYLLIAN LEIGHTON
CLARA DALE
PALMER BOWMAN
LOUISE KELLY
FRANCES BAYLESS
FRANK WEED
DAREL GOODWIN
CARL WINTERHOFF
F. J. COMMERFORD
THEO. GAMBLE
EDNA MAYO
Bert Sprottee
Sydney De Grey
John Rhoades
Hetty White
Ned Keardon
William Bailey
Larry O'Donnell
Hazel Holt
Jeff Bains
Nadine Pelham
F.R.Butler
Ingram (Cupid) Pickett
CLIFFORD BRUCE
MISS BOUGHTON
T. MORGAN CAREY
ROBT. MC GRAW
MR. BLAISING
MR. ROGERS
MR. NEWMAN
MR. BERRILL
MR. BENSON
Jack Mc Graw
BORAX O'ROURKE
VAILLI VALLI
Marie Empress
John E. Bowers
Sunice Millery
Minnifred Greenwood
Vernon Dent
Edith Sterling
Steve Clemente
Cheyenne Harry
Morris Foster
James Calvin
Ralph Carrington
Charles Bergen
George Kunkel
Tenen Holtz
Charles Meakin
H. Oboe Rhodes
Jackie Combs
Freddie Cox
Gloria Holt
Annabella Magness
Dave Kershaw
Ann Schaeffer
Jean De Briac
Tom Wentworth
Maryla Sokalska
Perry Merithew
Ben Graham
Susan Willa
Thorton Baston
Joseph Chailllee
William Norton Bailey
Jacquelin Gadsdon
Dois Baker
M. Mayo
J. Francis
Al Freitas
Nellie Gleason
George Arnold
Jim Kinkead
Romero Valdez
GABRIELLE GAUTIER
STANNARD DOLE
FLORENCE BROMLEY
PERCY MARMONT
EMILY FITZROY
EVE ALLINSON
Taylor
Page Brookins
Maurice Gibben
Orlando Jolley
Edwin Wallack
Duke Kahanamoku
James Spencer
Madge Tyrone
George Brennan
Jewel Mendel
Marjorie Reiger
Hopkins and Harris
Jack Burton
R.P. Thompson
Ethel Davis
Dwight Young
Marguerite Steppling
Claire Gamble
Betty Srack
Jack Mc Donald
Frank Abbott
JEAN HATHAWAY
William Jeffries
Dicky Brandon
Jacky Richardson
Frances Ross
Heinie Conklin
Arthur Stuart Hull
G. S. SPAULDING
HELEN DUNBAR
G. H. GOWLAND
Carl Brickert
Fred C. Williams
Fred Heck
Carol Seymour
Diane D'Aubrey
Charles De Roche
Josie Sedgwick
Charles Wyngate
Graham Petty
Malcolm Denny
Ted Allen
GALLI CURCI
HOLBROOK BLINN
JEANNE EAGELS
HELEN MACELLAR
ETHEL INTROPIDI
LUIS ALBERNI
VICTOR SOUTHERLAND
JOHN MORRIS
JESSIE RALPH
Arthur Hicks
John Warner
Marty Martin
Lucille Vard
John J. Sheahan
HAZEL CLARK
BILL
MARY DONELLY
Herbert Brennan
William Wellman
Ted Reed
JOSEPHINE MILLER
Madalyn Harlan
Bob Elkins
Ruth Cassell
Jerry Ryan
Modge Hunt
Sonia Marcelle
Lucia Moore
Otto Van Loan
Lou Archer
Manice Bunnham
James Seeley
P. C. Hartigan
C. Coulter
MAIRE WALCAMP
ALDREW WALDRON
THOMAS LINGHAM
EDGAR ALLEN
LEON DE LA MOTHE
animal actors
Frank Thomas
Hattie King
John Tansey
Louis Grissell
Jared Austin
Ben Gray
Arthur Houman
Fred Do Shon
Shultz
Mellie Carey
Jim Carey
Fred Jones, Jr.
Allan Grey
Tale Benner
Clifford B. Gray
J. Morley
Bertra Grossby
William Holland
Walter Chung
Aaron Mitchell
Young Hipp
Colin Kinney
Grace Horse
Joe Richmond
ELMY WEHLEN
John Terry
Hedda Kuszewski
Evelyn Terrill
Wm. Dale
Mavis
My Beth Carr
Vivienne Osborne
Dorothy Allen
Sheridan Tansy
John Dwyer
James Sheldon
Wallace Ray
Charlesogle
Joane Woodbury
Frederick Warde
Eugenio Besserer
Maryland Morné
Bessie Waters
Carolyn Rankin
John Hardman
Bruce Guerin
Myrtle Sterling
James Gould
Mrs. Maja Bjerre-Lind
P. Lazarus
Mrs. Stella Kjerulff
Kalman
Ruth Donnelly
A. H. Bushby
James Montgomery Flagg
Ruby De Remer
Teddy Brooks
Gladys Valerie
Jack MacLean
Mary Davis
Anita Brown
Marion Stewart
Lola Hernandez
Wanda Valle
James Finlayson
Louise Pazenda
Mary Haines
Julia Rooney
Janet Barker
James Hovey
Lucile Hovey
Thomas O'Keefe
Jimmy Barton
Betty Hewe
Ronald Bradbury
Bill Cauffield
SALLY FIELDS
Harland Knight
Unspecified
Harry Cording
Alfred Regnier
Clarence Hodge
Orin C. Jackson
Milton Moranti
E. Jensen
Armand Katz
Chas. Mailes
Bill Smithens
Jack Perrins
Lilly Butler
Guz Weinberg
CLEO RIDGLEY
MRS. JAMES NEILL
CHARLES ARLING
JOSEPH KING
JANE WOLFF
WILLIAM ELMER
BOB FLEMING
Marion Reeves
Jack Reeves
Dorothy Ponedel
Charlotte Leonard
D. Clayton Smith
Judge Clayton Herrington
Edythe York
Irwin Hardy
Thomas Dixon
Nannie Wright
J.Wharton James
“Mother” Anderson
Viola Dolan
Ruth Maurice
John A. Lorenz
Elizabeth Burbridge
Dexter McReynolds
Jack Milton
Nelson Hall
Wm. H. Turner
Richard Carter
Addison
Edwin Earle
Miss Murray
Madame Rosanova
Craig Biddle
Robert Hendricks
Selly Roach
Robert Holyoke
Max
Charles Coghlan
Bobby Agnew
Churchill Ross
Charley Paddock
Larry Peyton
Zazu Pitts
Mabelle Harvey
Virginia Chester
Molly Mc Connell
Laura Winston
Ann Shaefer
RUTH STONEHOUSE
Annette Revere
John Burrows
Dick LaRue
Slug Martin
T. Tannemoto
JOHN STANDING
Pierre Maillard
Phillip De Bus
James Carew
DERWENT HALL CAINE
Marian Swayne
Albert Froom
K. Barnes Clarendon
Alexander Hall
Ben Lodge
William V. Miller
Rita Jolivet
Jas. Corrigan
Myrtle Vare
Richard Gordon
Madeleine Marshall
Violet Biccari
Hildor Hoberg
Roy Southerland
Maude Baker
Margaret Pitt
R. H. Kelly
Mr. Holger Reenberg
Mr. Frederik Christensen
Miss Oda Rostrup
Mr. Viggo Wiene
BETTY STANDISH
JEROME KENT
GREGGS
ELIZA
FRANK BERESFORD
TOM TROTTER
JIMMY
UNCLE GEORGE
AUNT ISABELLE
Jewel Carmen
Marie Coverdale
Jule Powers
Gloria DuBois
Philip Coburn
Betty Coburn
Mershal Mayall
Alton Brown
Miss Blanche Forsythe
Miss Dora De Winton
Mr. Roy Travers
Mr. Robert Purdie
Nelson Phillips
Tom MacDonald
Rolfe Leslie
Tom Coventry
Rachael De Solla
ETTA ADAMS
THEODORE PARKER
MRS. STANCHFIELD
ADELE ROWLAND
MR. STANCHFIELD
JOHN CREEL
FRED NICHOLS
ROBERT LOWE
George Jessel
"Spec" O'Donnell
Tom Murray
Wm. P. Carleton
Lawrence Wheat
Incien Littlefield
Thomas Kennedy
JEAN PALLETT
CECIL C. HOLLAND
Jeanette Dawley
Benjamin Thurbett
Charles Cunningham
Frances NeMoyer
Miss Vivian Martin
Alec. B..Francis
Gyp Williams
Hazel Newman
Tom Wallace
Fern Watkins
Flora Pinch
MISS CLAIRE PAUNCEFORT
Beulah Booker
Maryland Morne
William Ryne
Bert Applin
MIRIAM COOPER
Katherine Kaelred
Gertrude Le Brandt
Bert Sutch
Lillian Clarke
Eric von Stroheim
Edward Patrick
Jacqueline Dyrus
Virginia Dixon
Ann Kronan
Donna Moon
Harry Morris
Al Hallett
Travers
Dora Rodgers
Larry McGrath
Alfred McKennon
Ida McKenzie
Louise Mayon
Margaret Wayburn
W. H. McCormick
William Calhoun
Jane Harvey
Dudley Hill
Howard Crossley
Rita Crossley
Mr. Titus
Master Billy Calvert
LEFTY FLYNN
Jimmy Anderson
Bob Bradbury
Cecil Ogdan
Miss Walbert
Will Mallen
Richard Livingston
Klint Martin
Rudolph DeValentino
Ruth Chatterton
Augustus Phiklips
Harry V. Meter
Elizabeth' Janes
Harry Swett
Eli Nadel
Morris Millington
Aanes Vernon
Marjorie Beardsley
Gerrardi Garaboldi
Paul Arnold
WINIFRED GREENWOOD
Carl Morrison
NORAH McDONALD
PAUL HOWELL
JUDGE KERR
ANNA COULAHAN
TOM COULAHAN
MRS. MALONE
JOHN MARSH
EDWARD BURTON
MAY BUSCH
JOSEPHINE ADAIR
CLAIRE DUBREY
LUKE SCAREY
Bill Matthews
Philip Colt
Daphne Van Steer
May Larrabee
Monty Newcomb
Tom Brooks
Adolf Milar
Edward Dawson
Kenneth Chalmers
Nora King
Leon M. Lion
Philip Howland
Manora Thew
Gwunne Herbert
ALICE WASHBURN
EDWARD O'CONNOR
MARTY FULLER
MRS. WM. DECHTEL
Sylvia Arnold
Sydney D’Albrook
Robin Williamson
Arthur Phillips
James Warren
J. W. McKay
Joe Monahan
Neely
Louis Carruthers
EDDIE GONZALEZ
Eleanor Shelton
Luara Lapante
Sarah Padden
Guinn Williams
Tommy Flynn
John Charles Thomas
Vivienne Segal
Dick Ramsey
Billy Dyer
Michael J. Hanlon
Joseph Wilkes
Margaret McWade or Core Williams
Charles Oro
E. Thompson
Ethel Kenyon
Ernest
Sophie Pagay
Hans Adelbert von Schlettow
Willy Fritsch
Liane Haid
Suzy Vernon
Elsie Vanya
Fritz Rasp
Ida Wust
Euna Ray
MME. NAZIMOVA
Nancy Palmer
NANCE O'NEILL
ALFRED HICKMAN
TYRONE POWERS
MME. MATHILDE COTRELLY
PAUL GILMORE
BEN GRAUER
MILDRED HOLLAND
THARMARA SWIRSKAYA
Wm. Fitchett
Betty Nathan
Orbie Farris
Lylillian Brown Leighton
ANNE CORNWALL
Harry West
A. Harrington
Sam Appell
Dave Butler
Ray Abbey
Bessie Bantam
Grace Davison
Ralph Osborne
Clayton Davis
Phyliss Gordon
Anna Baldwin
Dot Granville
Benny Corbet
Orpha Alba
Reed Howes
Lloyd
Micky Bennett
Barry O'Meara
Margaret Roll
Austin Conroy
Kate Jordan
Rena Rodgers
Joe Weston
Collette Lyons
Roland Sharp
Clayborn Jones
Tom Hing
Lee Gow
Hoo Ching
Lin Neong
Marshall Gibbons
Silas Hawkins
William Parker
Bobby Boulder
Eugene Lodchart
Betty Jewel
Robert Lee
Ralph Belmont
Henry Barnes
Bessie Gaythe
Samuel French
MR. GRASBY
G. A. WILLIAMS
MARY TALBOT
Vera Browning
Fred De Silva
Don Ferrandou
Grace Pierce
Fred Masters
George Wayne
George Montgomery
Grace Montgomery
Judge Davis
Marion Masters
Jean Hersholt, Ford Sterling, Arthur Lubin, Stanton Heck, Fred Warren, Arthur S. Hull, Kewpee King, J. Edwards Davis, and Leo White
Edward Connell
Mitzi Goodstadt
VIOTA DANA
Louis D'Arclay
Maree Beaudet
Phyllis May
George Gown
SESSUE HAYAKAWA
Forest Seabury
Tom Kurahara
JANE PARKER
JAMES CORRIGAN
MARGARET LIVINGSTON
FREEMAN WOOD
GEORGE FISHER
PHILIPPE DeLACY
Winthrop Chamberlain
William W. Jefferson
Ina Brooks
E. M. Kimball
Templer Saxe
Harry Clay Blaney
Herbert Harwood
Janet Harwood
Hilary Herndon
Leslie J. King
Henry Nelson
Perry Bascom
Pat Sullivan
Eddie Quillan
Ray Turner
O. A. O.
Will E. Sheerer
JACK DUFFY
Violet Bird
Jimmy Harrison
"Kid" Wagner
Madge Keene
AURELE SYDNEY
J. L. V. LEIGH
SIR GILBERT TOWNSEND
A. CATON WOODVILLE
ARTHUR HOOPS
ALMA HANLON
Carlyle Fleming
Fred. Huntley
Hugo Schultz
Michael J. Madden
Peter Ryan
Ralph Laidlaw
Anton Dow
Helen Orr
Armand Cottes
Kirke Brown
Arthur Mackley
Arthur Baldwin
Cladys Kingsbury
Katherine Wilson
Billie Jean
"Queenie" Kate
Naomi Waldon
Ezra Waldon
William Sherer
MARIE DRESSLER
Vincent Byron
Mina Taylor
Geoffrey Storm
John Bryson
PHILIP GARST
STEVE KING
EDDIE QUILLAN
Betty Wales
Mercita Esmonds
Ida Fitzhugh
Grace Victoria Forde
Tom Tom Mix
Centiped Pete Joe Ryan
Jordan Sid Jordan
Ann Andrews
Allen Edwards
Kenneth Hall
Sam E. Minter
the actress
Carleton Macsy
Lillian Paige
Allan Hale
Boris Korlin
Tom Meyers
James Vincent
Roy Sheldon
John A. Boone
Violet Stuart
JOHN HARRON
Macklyn Arbuckle
Andre Tourneur
Tom Mills
Vitturo Caggoni
Marjorie Holbrook
John Clayton
Gertrude Arnold
Sheridan Tansey
ADA SNYDER
MRS. BRYANT
Florence Johnstone
Albert Phillips
May Blossom
Lyons Wickland
Allen Connor
Beuhlah Booker
Valma Whitman
Enid Burne-Smith
Allen Winthrop
Miss Wilmer
JOHN W. COPE
MISS LUCIA MOORE
HENRY HULL
WHEELER DRYDEN
WILLIAM JEFFERSON
SYDNEY BLACKMAR
OTIS SKINNER
FLORENZ ZIEGFIELD
DANIEL FROHMAN
HENRY MILLER
BLANCHE BATES
JOHN PATRICK
Lynn Cowan
Baby Delameter
Alan Boyd
Fred Nicholls
James Terbell
Margaret Elizabeth Faulconer
George Fischer
Julian Ormond
A. Von Baussen
Richard Wangerman
Charles D. Mackey
Dick Earle Foxe
Miss Olivia Blanche Davenport
Adam Raskell
Willie Raskell
E. M. Favor
Wm. Dwyer
Will Hopkins
TOM HEALY
La Fayette McKee
TIM SHEA
Geo. Pearce
Jas. Farley
Mr. Hahn
Miss Hallenbeck
Pat Kelley
Judy King
Dan Bowers
Violet Manners
Marion Manners
Reggie Barrett
Reggie's father
Harry Donovan
Bill Tait
Parson Brown
The Mayor
ELEANORE STYLES MARSTON
Richard Thornton
Powers Fiske
Dr. Stephen Trow
Angus Hood
Nadya Lesienka
P. A. Baksheef
N. V. Panoff
Sophie Karabana
Beverly Abyne
Gerald Griffin
Thomas Blake
John Judge
Elwell Judge
Nally Crute
BILL HARCOURT
JIM HARCOURT
Harry A. Burrows
Edna Dumary
George Atkinson
Willard Lee Hall
Mary Hearn
Eugene P. et
Warren Wait
Hugh R. Thompson
FAY TINCHER
Mrs. Constance Lee
Mary Land
WILLARD MACK
Charles Brant
Macey Harlan
Jean Stewart
Vic. Frith
Ross Fenton
Sally Crater
Angel
Sheriff Upshaw
Aunt Crater
Jeb Poultney
"Draw" Eagan
Jack Mason
Jim Ruddy
George Carr
Andrew Blair
ROBERT KINCAIRN
Erville Alderson
Col. G. L. McDonell
Bessie Gale
Henry Morton
Robert Goodman
May Gibbs
Dr. Stone
Emma Kluge
Thomas Carrigan
May Buckley
LOU-TELLEGEN
THOMAS DELMAR
LAURA WOODS CUSHING
JOHN McKENNON
DICK CRAWFORD
W. R. Weber
L. D. Maloney
Irene Yeager
Arthur Redden
Rita Harlan
Bianca Sylva
Antonio Manatelli
Etienne Du Inette
Jules Lavinne
Marion Singer
Alice Carlton
Mabel Strong
ANN FORREST
FONTAINE LA RUE
FREDRICK VROOM
MAY GIRACI
JOHN CURRY
ADOLPH MENJOU
EDWARD VROOM
Sweeney
Richard Larned
Pearlie May Norton
Elsie Lorimer
George Hackathorn
Phil Gastrock
Miss Elisabeth Risdon
Graham Trevor
Mrs. Muir
Wharton Jones
Henny Porten
Mr. Noswowski
Mrs. Whistler
Fred Aldis
Gilbert Kildair
Krantz
Paches Jackson
Charles Richman
Barbara LaMarr Dealey
James Rose
Louis Leon
Thomas Lehmann
Gerald Du Maurier
Craig Kennedy
JULIANNE JOHNSTON
EMILY CHICHESTER
Mr.G.M. Anderson
Paul Dickey
Lloyd Talman
Jesse L. Lasky
Miss Allen
Miss Ellis
Mr. Scott
EDWARD COXEN
GEORGE
JOHN STEFFLING
W. J. TEDMARSH
Brandon Tynan
Doré Davidson
Stanley Ridges
Robert Lee Keiling
Billy Quirk
Helen Macks
Gay Pendleton
“Pop” Kennard
Robert Carson
William Bowers
Gladya Leslie
DICK BAIRD
TOM MORAN
Louise Kelly
Jack Jensen
Charles Gotthold
Jack Wilmer
Louis Blake
Edward Weins
Ethel Miller
CARRIE SIMPKINS
Kate Denton
Alfred Denton
Conrad K. Arnold
May Gale
Pete Gale
Martin Jess
Wallace McCutcheon
Ned Sparkin
DOUGLAS MacLEAN
Clare McDowell
San DeGrasse
William Bainridge
Henry J. Herbert
Asche Kayton
Windham Standing
Mervyn LeRoy
Virginia Jones
Robert Tansey
John Ardizoni
Tiny Alexander
James Welch
Joe Gadsen
John Richardson
Mona Kingsley
Carl Hartmann
Joe Slavak
Hiram Osborne
AL WILSON
Josephine/Ditt
Ed KEMM Coxen
Allen
Marci Torpie
Tote Ducroc
Helen White
Mrs. Seegar
Jay Scott
Lillian Ten Eycke
Joe Hanrahan
Marie Ducette
Bat Kennedy
Irving Ducette
GENE PERRY
Don Barclay
Doris Fellows
Tom Foxman
James C. Barrows
Richard Hendrick
William DeVaul
Thais Lawton
Mabel Treneer
Harry English
Turner Savage
Maud Clark
Tom D. Bates
George Reed
L.M. Wells
Eunice Van Moore
Charles Edler
Frank Mason
Edna Mason
Little Billie
Bob Grant
William Brunter
J.W.John
Mrs. W.Cull
Walter Weems
Ed Gar
MARY TOWNSEND
JOHN
CHARLES CLAY
LEONA TRETONN
Ada Boshell
Alex Saskins
Olga Humphreys
Edward Donneley
Irene Tams
Baby Esmond
Cecil Rejan
Gloria Gallop
Wm. Carr
Vivian
Louis
Reaves
Harry I
Marvin Mayo
William Parsons
JACQUELINE LOGAN
JASON ROBARDS
Mabel Julianne Scott
Robert Van Nuys
Harold Vizard
Mrs. Waters
Miss Waters
Johnie Walker
Henry Dyer
HARRY LANGDON
J.E. Johnston
WILLIAM CARROLL
ASHTON DEARBOLT
PHIL MAY
W. H. Rhyno
Lea Errol
Miriam Hembitt
Roland Bottomly
Jim O'Neal
William Harrison
Jimmy Karr
Beatrice Beneful
Stephen Karr
Elmer Boeseke
Linnie Gee
Dora Rodger
Toto
Arthur Currier
Virginia Boardman
Lisamae Grey
Ernie Shield
Jane Burnuly
Chas. Learned
Barney Bernard
Bernard Carr Gordon
Edw. Durand
Leo Donnelly
Thomas Wells
Charles Hill
Lorraine Eddy
Jack Henderson
WALLACE MacDONALD
JOHN ROCHE
PURNELL PRATT
Marcia Bowers
Olive Corbett
O.N. Hardy
Margery Wilson
Wm. H. Bainbridge
William Conway
Charles Vassar
Jas. B. Warner
Miss Evelyn Nesbit
R. D. MacLean
REX ROSELLI
Noah H. Beery, Jr.
Norval MacGregor
Patch
Margaret Quimby
J. Farrel MacDonald
J. Walters
Ed. Jones
Geo. Fernandez
Ferd O'Beck
Patsy DeForest, Nancy Barring, Flora Williams
Eddie Smith
P. MCCULLOUGH
GEO. CHESEBRO
MRS. A.E. WRIGHT
DELLA ARNOLD
Jim Rayburn
Henry Desmond
Sir George Gravy
Sir Henry Spoon
Miss Van Hillside
KATE ARGONET
Randle Ayrton
Edward Sorley
Madeline Clare
Bill Borden
Jane Aubrey
Henry Alrich
Ruth Judson
Hugh Lee
Ephram Judson
Tom Judson
Anton Vaverka
Olive Ann Alcorn
Bert Delaney
Ethel Lawrence
WILLIAM H. CRANE
BUSTER KEATON
Odette Tyler
Helen Holte
Henry Clauss
Julia Sturart
Will E. Sheerett
Nels Ormsted
Gilda Gray
Alice Maison
ARTHUR JASMINE
MARICIA MANON
LASCA WINTER
CHUCK REISNER
MAX DAVIDSON
KATHERINE DAWN
STEVE MURPHY
Cora Drew
Ritchie MacDonald
Emily Dwyer
Ralph Graham
Skaguay Belle
Andy Walsh
William Hillyer
Elizabeth Rysdon
Ives Pomeroy
Sammy Bolt
Moleskin
Matthew Northmore
Jill Wickett
Ruth Rendle
Brothers Toop
The Doctor
Richard Rosson
Harry Duffield
Walter Morosco
MARIE PAVIS
Theodore Lerch
Miss Tennant
J. W. Sohnston
Miss Stuart
C. Lillard
Ryan
MILDRED HARRIS
Alfred Pagent
Kirk Brown
Ethel Stannard
Marjoria Ellison
Joe Lanning
George Belville
Ernest Cook
Louis Rivera
"Happy" Rosseli
Ed Daton
?W. J. Tedmarsh
Lotta Cruze
Gerald Robertshaw
Maxudian
Count de Limur
Paul Vermoyal
Justa Uribe
Giuseppe de Campo
Paul Francesci
Alexandresco
"Fatty" Loback
Alile May
Cooper Cliff
Sidney Dean
Sydney Haben
Mrs. Alexander
Mary Tabbot
GEORGE BEBAN
Wanda Lyon
Baby Evelyn
Nettie Belle Darby
O. Vangrilli
Helen Holcomb
Maria Di Benedetta
William Howat
John K. Newman
George Humbert
Joseph Phillips
Dorothy Benham
Leland Benham
Ethel Kaye
Harry Sothern
Edna Wallace Hopper
Jane Morgan
Mr. Grasby
R. HAYES
Arthur George
Mary Hall
S. Zeliff
Edw. Sloman
Amy Dawe
Dick Larimer
Asa Judd
J. Nutt
Jas. J. Corbett
Wm. Sauter
Jack Dale
William Burke
Tom Nelson
Suzanne Brooks
Josiah Brooks
Pennington Crane
Jimmie
Ford
Senor Emanuelo Romez
Senora Flora Romez
FRANK MCQUARRIE
JEAN HERSHOLTZ
Harry Ds More
Lido Manetti
Hans Vedder
Jan Kraga
PRINCE PAUL ALEXIS
BORIS DOLOKHOF
KARIN DOLOKHOF
Daniel Willard
Ruth Willard
John Baxter
Miss Rose Evans
Josephine Luria
Mr. & Mrs. Carter DeHaven
Wallace-Lupino
SALLY BRENT
WILLIS OTT
GORDON WEST
Arthur Emery
Carlo Weith
Jenny Larason
Clara Weith
John Ekaman
Axel Weslau
Justus Hagman
Thomas S.Guise
Ione Atkinson, Mila Constantin, and Hortense O'Brien
Fred Ganbold
Percy Williams
BOB FULTON
ROSE DE BRAISY
JACK KING
CLYDE HOLT
BETH HOOVER
HENRY A. BARROWS
Evelyn Thatcher
Wm. White
Adolf Mueller
C. A. Bachman
Hal Calthrop
Bernard Seigle
Lina Basquette
Hugh Trevor
Howard Van Dyck
Helen Robyn Adair
TED WELLS
Bill Bevans
Florence Coventry
Mr. Eckstein
EDDIE SOMERS
ALICE PAGE
HOWARD MASON
RICHARD VAN NORMAN
Thornton Church
John Slavin
William Burress
William Castelet
Fred Wyatt
Chas. A. Smily
C. LIVINGSTON WIGGINS
Wm. Bertrem
All Craig
Ernest Boulain
E.H. Sothern
Edward J. Burns
Brian Darley
LEONARD FAYNE
ISABEL GRAYCE
KATHERINE DARE
HEMINWAY
ELLA KLOTZ
MINNIE BALDWIN
LAURA
Mary Carson
Dan Hanlon
Kittens Reicherts
William J?Dyer
Mrs. J. H. Brundage
Horace Knight
Ina Rorko
Mildred Arden
Theresa Maxwell-Conover
James Gleason
Alan Martin
Katty Lee
Nathan Bush
Mildred K. Wilson
FRANK MERRILL
Al. Earnest Garcia
Mary Crouse
Thomas West
Richard Angus
Emory Johns
Clarence McGinty
Charles Darling
Gale Galen
Judy Wilcox
Rags Dampster
Nate Shapiro
Kelly
Spence Brock
Mrs. Wilcox
Stubbs
Mr. Brock
Maurice (Lefty) Flynn
Jean Tolley
Mr. and Mrs. Carter DeHaven
Jean Carson
A.N.Millette
GRACE HAMLITON
R. F. Hill
Glenn White
Jenevieve Bouchette
John Walton
Fredk. Starr
Eleanor Baine
Frank Truax
Walter Paxton
Van Dyke Brooke
Armand F. Cortes
Sue Willis
Anna Jordan
Julia Walcott
Robert Lawrence
Vivian De Wolfe
C. Shropshire
Katherine Reynolds
Amelia Badarracco
Katherine Vaughn
Miss Bancroft
Gertie Miller
Marion Coleman
C. Morris
De Forrest Dawley
Fred Nichols
Della Buckridge
Gerald King
Mr. McPhee
Geo. Moss
Messrs. Quinn & Calder
Lottie Winneltt & Mrs. Cortes
Mr. Elkus
Goe. Rickets
Misses Free & Golfinkel
Miss Gormely
Miss Birch & Andrews
Miss Crane
Miss Earl
Ford West
Billie Bevan
George Towne Hall
Rita Ashley
Cora Maitland
Thomas Houpe
Warner P. Richmond
Ray Chamberlain
Edward Gillace
James Hamel
Ruth Fuller Golden
Fontaine Le Rue
Marry Charleson
Mery Astor
Larrimore Johnston
Fenwick Oliver
Roland Bottomley
Aileen Mannin
Evelyn McCoy
Bertran Johns
John W. Dillion and Jack Richardson
Jenny St. George
Kathryn Kennedy
T. R. Williams
E. A. WARREN
EDWARD BURNS
NIGEL de BRULLIER
DALE ALDIS
JOHN COVENTRY
PHILIP LESWING
DALE ADDIS. (Young)
GLENNY
Robert Harding
Jack Abbot
George Bonn
MARGUERITE NAMARA
RODOLPHE VALENTINO
ALBERT BARRETT
HENRIETTA SIMPSON
ARTHUR EARL
WALTER CHAPIN
AILEEN SAVAGE
ALEX. K. SHANNON
GENE GAUTHIER
Rose Day
John Forrest
August Wolf
Richard Harding
Tom Thornton
WM. FAIRBANKS
ARTHUR MACKLEY
Bob Mortimer
Miriam Wiggins
Homer Waldron
Ephraim Bates
Elmer Tuttle
"Buddy" Messenger
William James
Alice Hedman
Lillian Loring
Ralph Hedman
Gerald Hedman
Gloria Gordon
ZENA KEEFE
ROBERT ELLIOTT
JACK HOPKINS
JACK DRUMIER
JAMES MILADY
ROY GORDON
GYPSY O'BRIEN
DOROTHY ALLEN
TED GRIFFEN
MASTER JOSEPH DEPEW
WILLIAM FISHER
Miss Percy Read
Daisy Evans
Berd O'Beck
George Marion
Capt. T. E. Duncan
Fred Gable
Shirley Aubert
Rita Dane
Norah Sprague
Bruce Biddle
John Fairbrother
Irene Aldwyn
Max Stanley
Billy Bennett
G. Clayton
E. Laidlaw
Al Hueston
Tom Delmar
Wally Van
Jesse J. Aldriche
ROBERT DENMAN
HENRY MORSE
RONALD COLMAN
GEORGE K. ARTHUR
WILLIAM ORLAMOND
ERWIN CONNELLY
MACK SWAIN
Rosalie Lenormand
Pierre Laroux
Eugene Cameron
Mae Wells
Besse W. Wharton
M.W. Rale
Dick Warrington
Anna Warrington
John Bennington
Howard Estabrook
Elsie Wilson
JOHN GOUGH
Captain Ward
Jude Clark
Vaughan McAndrews
Judge West
Wallace Harrison
Dave Bean
Victoria Harlowe
Wainwright McAndrews
Slim Perkins
Emeline McAndrews
Abner Clark
John Faulkner
John Casgrove
Raymond Lawrence
Gerald Hargourt
William Tooker
M. Durant
Jeffrys Lewis
Neill Kelley
Milton Herman
Florence Ashbrook
Lady Diana Manners
Gerald Lawrence
Alice Crawford
William Luff
Lennox Pawle
Rosalie Heath
The Hon. Lois Sturt
Elizabeth Beerbohm
Victor McLaglan
Rudolph de Cordova
Gertrude Sterroll
Fred Wright
Violet Virginia Blackton
Tom Heselwood
Lena Rogers
Tison Grant
Paul Rogers
Myrtle Reeves
F. A. Turner
JOHN BONHAM
HELEN HARDING
REX RADCLIFFE
WILLIAM HARDING
AMALITA CORDOVA
HARVEY WEER
MRS. HARVEY WEER
Mr. Frank Tennant
Mrs. Francis Turner
EDMUND BREES
Dorothy Graham
Marie La Corio
‘‘Baby’’ Mack
D. Roseborough
Audrey White
Nora Lane
Bert Hadley
Beans
Olin Francis
Dudley Hendricks
JERRY DREW
Bob Graves
Eddie Featherstone
Chas. Jackson
ELSIE VAN NAME
Dorothy Roth
Captain E. H. Calvert
George Morrison
Ed Roseman
Rod. LaRocque
Marie Chambers
SAM DE GRASSE
FRANCELIA BILLINGTON
H. GIBSON-GOWLAND
VALERIE GERMONPREZ
C. W. Bachman
Marion Bent
George Seigman
Fred Kirby
Mary Welsh
Dorothy Reynolds
Barbara Butler
Arline Blackburn
Jack Grattan
Adelaide Stegman
Emma Dunn
Audude Brook
Joe Burke
Charles Winninger
FRITZIE RIDGEWAY
HARRY TODD
RUSSELL POWELL
EARL PAGE
T.Huntington Forbes
Mildred Vandeburg
Augustus Vandeburg
Mrs.Vandeburg
Simonds
Mrs.Merriweather
Rev.Alfred Clemons
Jessylee Roberson
Meeda Jones
"Spike" Jones
Gerald Courtney
"Jep"
Dan
By Herself
Martha Francis
Herman Heller
Bert Marsh
Amy Marsh
RICHARD FARQUHAR
HAL CLEMENTS
William David
Little Mary
Mrs. Maclyn Arbuckle
Robert Thorne
Nicolai Koesberg
Geo. Siegmann
Edwin Argus
Princess de Bourbon
Wilfrey Noy
Kenneth Maynard
Spencers Charters
May Vokes
Douglas Stevenson
Harlan Knight
Joe Raleigh
Herry Peterson
Isadore Marcel
Keane Waters
ARTHUR STUART HULL
STANHOPE WHEATCROFT
EULALIE JENSEN
ERIC MAYNE
Alex Hart
Barney Gilmore
Florence Ulrich
Wilm
May
DON MIGUEL ARGUELLA
BOB REEVES
Honest John Andrews
Edgar Kennedy
Norma Wills
Fred. C. Truesdell
Robt. W. Frazer
Bert Schable
Edith Conway
Joseph Chatterton
Anne Vance
Richard Vance
Mrs. Ordway
June Rose
MARION BUCKLEY
JAY ROGERS
LEON KESSLER
LILLIAN RICH
NANCY CASWELL
LIEUT. MARCEL DRAGEAUSON
SALLY CRUTE
Wilmuth Merkyll
W. L. Abingdon
JOHNN CHARLES
WALTER ROBERTS
Boland
John J. Haggleton
Moran
Gentle
Jenny Moran
Philip Ames
Margaret Lawrence
Ole Olson
Frieda Nilssen
Dick la Reno
Gustaf
Sallie Fisher
Daniel G. Tomlinson
Roger Durant
Professor Aldrich
Mrs. Gauthier
Paul Paret
Erdman
MINA ROGERS
HARVEY GORMAN
DR. PRINE
ROBERTS
CAL MORGAN
John Girdlestone
Ezra Girdlestone
Tom Dimsdale
Wyndham Guise
little Joyce Marie Coad
BOB CUSTER
Mary O'Day
Bert Sproutte
Carlo Scipa
Zita Ma-Kar
Walter Mailley
EDWIN N. WALLACK
SYLVIA BREMER
CHARLES O. RUSH
ALMA RUBENS
JOE KNIGHT
Bert Wall
Katherine Drew
CODLEEN MOORE
Edmund Stevens
Edith Yorks
Miss Cherrie
Major Rice
Ruth Foyce
Harold Holland
Emily Gerdes
Harry Allen
D'Aroy Corrigan
John Ryan
E. F. Power
B.K. Roberts
Nannie Pearson
Mrs. Chas. G. Craig
Pat Hardigan
RENIE MATHIS
Eric Southard
Bud Weaver
CHARLES DELANEY
"Buck" Black
Roy McCray
Bertha Burnham
Betty Brice
Adelaide Brent
George Ruth
Marion Sterling
Hugo Smith
The American Actress
William C. Dowtan
Tony Loftus
Charles Hyatt
Ann Forrestt
Maude Wayne
F. R. Butler
F. Templar-Powell
Jim Adams
Anita Burrell
Wilfrid Roger
Betsy Bacon
Ethel Tears
TED DUNCAN
CHARLOT MOLINA
J. P. Connley
George Woodward
James Varley
Hattie Delano
Maurice Summers
Maric Walcamp
Evelyn Seibie
Lola Martinez
Archibald Rivers
Donald Gaynor
Mary Harrison
Valasques
Wilkes Gamble
Matthew Betts
Charlie Fong
Regina Sarle
Wilbur Highby
Dorothy Markham
Bob McKay
Jack Edwards
Emma Hanford
George Kingsley
Miss Wright
Jack Pierce
MATTY ROUBERT
Dick Alden
Mary Truesdale
Milicent Carter
Rodman Grant
Josiah Blake
Jim Titus
Maggie Trask
Bill Ward
Mrs. Marvin
Lou Dunbar
Miss Perry
Beatrice La Plante
Earl Martin
Jack Byron
Antonio Cardonio
Lucie Cardonio
Gaston De Versey
Joe Weber
Wm. F. Clifton
FRITZI RIDGEWAY
EDWARD O'NEILL
KENELM FOSS
FRANK STANMORE
VERA CUNNINGHAM
ELISABETH RISDON
Jeanne Darcey
Boris Norjunov
Ruth Turner
Rosita Maristini
Albert Miller
Caroline Meredith
Mark J. Elliston
Lane Chandler
George "Buck" Connors
Jay Morely
Russell Walton
Mona Palma
Lola Daintry
Charles Force
Charles Smiley
Loyola O'Connor
HELEN RIAUME
CORA DREW
RENE ROGERS
HUAN DE LA CRUZ
C. NORMAN HAMMOND
WM. J. HOPE
MARJORIE BLYNN
WM. HABEN
W. Welsh
Lillian Russell
Henry Clive
Eugene palette
William Knight
J. Delos Jewkes
Will E. Lloyd
Jack Reid
Robert Reynolds
Marie Lacouvrer
Geoffrey Webb
Spoitswoode Aitken
Jane Simpson
Michio Itow
America Chedister
Betty Carpenter
Sam Kim
H. Takemi
Patricio Reyes
John Talboys
Helen Talboys
Robert Audley
Sir Michael Audley
Gertrude Messenger
Jean Moyer
Carlos Lopez
Victor Rodriguez
E. J. Piel
Betty Lamb
Joe Mills
GUY BATES POST
Will Jim Hatton
Maurice B. ("Lefty") Flynn
John Gribner
Bruce Reid
Raymond Whittaker
MALCOLM DUNCAN
WM. ANKER
HERBERT HAYES
FRANK BELCHER
RUBY HOFFMAN
Hazel Hubbard
George Bean
Catherine Craig
Lu Celley Younge
J. C. Harper
J. A. Horley
Beulah Peyton
Warren Kerriga
Jeff Renaud
Mr. Brizard of the Grand Guignol Theatre
Mrs. A. Batys
Mr. Croutrois ef-the-Odeen-Theatre-
Mr. Pierre Foirey
Mr. Dark
Mrs. Berangere
R.H. Gray
Frank Forrest
Viola Dexter
Bruce Hilton
Marion North
Frank North
Harriet North
John Banning
MARY ASTOR
Roel Muriel
Andre Cheron
Christina Montt
Henriette Kathlyn Williams
Louise Winnifred Greenwood
T. J. Carrigan
Art
THEODORE KOSLOFF
KALLA PASHA
SIDNEY BRACEY
FRED BUTLER
ALAN HALE
Fat Randy
Ed. J. Brady
Jack Conly
Betty Baylock
Robert Baylock
Connie Damarest
Jack Grey
Aunt Sarah
Ralph
Jack Herrick
HELEN COUGHLIN
MRS. C. JAY WILLIAMS
MRS. WM. BECHTEL
ELIZABETH MILLER
EDNA HAMEL
BARRY O'MOORE
Ferd J. O’Beck
Bess Alexander
Kate Renaud
Richard Leslie
“Queenie” Kate
Phyllis Boggs
William Boggs
Reginald Carter
Roswell Johnson
William Graham
Fanny Ward
Edith Hardy
Utaka Abe
Hazel Childers
Nellie Lindrich
Mrs. F.O. Winthrop
Karl Breitman
Kedda Gobert
John Fitzgerald
Laura Killegrew
Loel Stuart
Mae Giraci
Kamuela C. Searle
Manilla Martan
Frank Morrell
J. W. Warner
Lillian Biron
Rob't Anderson
Harry Cornella
Paul Stanhope
Miss Brady
Ettare Forni
Oliver Ellis
Mrs. Hill
Milly Sayres
Anthony Fry
Mary Willard
NANCY PRICE
VIOLET CAMPBELL
HARRY WELCHMAN
WINDHAM GUISE
NELSON RAMSAY
JAMES LINDSAY
TOM REYNOLDS
ALFRED BRYDONE
Ford Pennimore
Will Louis, Jr.
Ann Gray
Richard Manning
Howard Van Kreel
Friend of Mrs. Van Kreel
Attorney for Mrs. Van Kreel
Charles Smith
Josephine Morse
Hattie Horne, Jennie Mayo
Marjorie Helmer
Robert Grant
Melville Kingston
Edward Horton
FATTY" ARBUCKLE
Ed Fisher
Clement Easton
Webb
Agnes Vinea
Marie Crisp
Wm. Fredericks
Edith McAlpin
Isabel Vernon
John Brown
Mr. Cooley
Bobby Roberts
Mary Delschaft
Kurt Hiller
Emile Kurz
Charles Howard
Ed Norton
Ada Meade
John Graves
Julia Courtell
PHILO McCOLLOUGH
RALPH DE PALMA
Harley Moore
Harry La Verne
Paul J. Derkum
Eddie King
James Gray
Jay Moreley
Charles E. Brickley
Dick Cummings
Mary Phillips
Jack Pearson
Lilly Loney
Bob Higgins
Mabel Healy
GRACE HARTLEY
RICHARD DAVIDGE
RUTH BOWMAN
Cap'n Scudd
Aunt Agatha Pixley
Eric Pixley
Jim Hawley
Eliza, the nurse
Mike Burley
Agnes Bowman
Capt. Arthur Clayton
J. P. Morse
Stuart Travers
GIOVANNI MARTINELLI
LOUIS D'ANGELO
THELMA HAUGH
Arthur Clippinger
Elsie Mobley
Hazel Hinchman
Faye Jones
Lena B. Jones
Jack Osborne
Bob Osborne
MARTHA BOUCHER
Pearl Weldon
Winthrop Waldon
ORMI HAWLEY
EARL METCALFE
Irene Morris
Frank Herrod
Oliver Morton
June Caprice
Arthur Albro
William H. Thompson
Rose Louise Huff
Bill Perkins
Charles LeMoyne
George A. Williams
Mark Senton
James Cartottle
Leopold von Ledebour
Albert Patry
Reinhold Schunzel
Charlotte De Felice
L. Davril
Harry Sellgood
Jack Bandle
Marjorie Holmes
Mr. Evans
Professor Dow
Chick Collins
Billy Hampton
Mary O’Brien
Malcolm Blevin
Norna Talmadge
Albert Presco
Betty B outon
Carrol Nye
Charles Edward Bull
Orpha Alber
Leonard Mellon
S.D. Wilcox
LILLIAN GISH
JALTER PAGET
Amy
Mrs. Wheeler
Mrs. Trott
The Angel Child
Julia Ray
Al. McQuarrie
Grace Maclean
ED (Hoot) GIBSON
Grace Nolan
Art Jordan
George Berge
William Taylor
Alfred Clark
TSURI AOKI
G. KINO
M. MATSUMATO
Trixy Lynn
Jack Weston
T. W. Bisbee
Y Marc
NEL BENSON
Edgar Reeve
John Masters
Cleone Loring
Charles Dorien
NAN KENNEDY
Billy Bond
John Lawson
Ben Farraday
Mme. Estrelle
James Bond
Robt. W. Fraser
Bina Payne
WALLY BURNS
MARY MAC CLARON
Toni Wylde
Rdin Van D'Arcy
Samuel Dodge
James Bowen
Kathryn Hutchinson
Betty Marvin
Dick L'Estrange
BILLY VAN DYKE
Jean Walsh
George Howell
Harry Hocky
Robert Vivian
Hilda Gordon
Henry Tracey
Norman Jefferies
Ed. Roseman
Rae Ethelyn
Robert Ober
Mildred Vincent
Robert Agnow
Audrey Ferris
Sally Eilers
Jack Santoro
Dan Crimmins
Jane Lowe
Dan Willis
Corey Houston
King Donald
George Ferris
Russell Hopkins
Bill Dillon
John Taylor
Karleen Day
Utahna LaReno
Mrs. Al W. Filson
Marguerite Arnold
Tom Burroughs
Audrey Munson
Art Lee
Virginia MacMurran
Tyler Hellis
Jimmy Redman
Billy Dawson
Jim Marshall
Mary Powell
Alan Holubar
Allen Garcia
C. M. Williams
Anna Bos
MRS. WALKER
LEO. D. MALONEY
Bob Burns
Miranda Platz
FULLER MELLISH
RILEY HATCH
WALTER GREENE
AGNES AYRES
EDWARD KEPPLER
Percy Pembrook
Percy Haswell
Dana De Harte
Robert Fuller
Harry Linkey
CHARLES H. MAILES
Wm. Demarest
Chas. Winninger
Fritzie Ridgway
J. E. Nichols
Alex’der Shannon
Otto Taylor
H. B. WARNER
VIRGINIA PEARSON
ROCKCLIFFE FELLOWS
Dainty Louise Huff
William J. Spencer
Vivian Caples
Charles de Revenna
Carrie C. Ward
Bill Lowery
Grace Eddy
Julian
Robert Gray and J.J. Colby
Wayne Craighill
Joseph Gerard
Margaret Scervin
Wm. W. Black
Evelyn Axxell
Diana Manners
Mary Mac Laren
Holmes E.Herbert
Rita Rogan
Lucia Backus Segar
Lou Ellen Carter
George Budd
Jackie Sampson
Miss Penelope Budd
Judge Daniel Carter
Mrs. Carter, his wife
Constable Simms
Dean of Richguys College
Maurice Bennett Flynn
John Spencer
Majorie Ellison
Virginia Carlin
Anita Booth
Fanny Cogan
George Cowle
Lillian Wiggins
Juliette Benson
Edward Sass
Laura Lyman
Pathe Lehrmann
Wolf Larson
May Giracci
C. Renfeld
W. J. Irving
F. Butterworth
Alberta Ballard
Virginia Griswold
Charles Kent
Vincent Cordez
Stuart Kent
Elizabeth Breen
Jack Kelly
Jim Fulton
Hart Horie
Patsy DeForesti
ANNETTE DELANCEY
WM. BARLOW
Robert Sterling
Herbert Carlton
Grace Blow
Gordon Harris
Aleene Burr
Thomas McGrane
John Butler
Charles McNaughton
Harry McNaughton
Alicia Turner
John Francis
Giovanni Pallazzi
Bob Huggins
Agnes Copelin
Bert Hunn
Geo. Routh
UNITY BEAUMONT
Margaret Vaughan
Albert Austin
Jean Scott
Willard Cooley
Richard Lee
Sarah Bernhardt
Alt
Jack D
Aubr
F
Ali
QTIS HARLAN
Chester Bennett
Mr. Guy Oliver
Mr. Fred W. Huntly
Mr. Al. W. Filson
Mr. Geo. Hernandez
Miss Stella Razeto
Mart Long
Eileen Cassidy
A. A. Kosumdar
Mollie Roberts
Charles Charles
Dan Halliday
MALCOLM SOMERS
BROCK
STEVE HARDEN
Robert Whitter
Master Richard Headrick
Anna Browne
Margaret Fitzroy
Lottie Case
Charles Trevor
Lionel Bellmore
Chas. Dorien
MYRTLE STEDMAN
TSURU AOKI
HERBERT GRAHAM
THOMAS KURIHARA
GEORGE KUWA
Jim Marsh
MARGARET MORRIS
Turdock MacQuarrie
Chas. H. West
Gladys Hullette
Ralph Gordon
Stella Gordon
Sarah Malcomb
Allan Standish
Harry Lightfoot
Helmar Bergman
Ed. Hearn
Rose Shirley
Biminsky Hyman
Frank DeSilva
Grace Studdiford
H. J. Carvill
Sidney Herbert
Edouard Durand
John Junier
PAUL KRUSER
"BABY" LILLIAN WADE
Clifford Bruce type
Grattan type
Herbert Frank type
Alice Hegeman
Lolita Robertson
MR. JOHN LAWSON
FRANK SEDDON
CHARLES STAFFORD
HENRY LUDLOW
ROLLO BALMAIN
MISS LUCILLE SIDNEY
Esther Wood
Patrick Herman
Mrs. Joe Martin
Baby Dougherty
Dallas Cairns
John H. Goldsworthy
Sidney d'Albrook
Slim Pagette
A. MacPherson
Veronica McSnagley
John Burton
Kenneth Scott
Gretchen Léderer
George Bothner
Buster Irving
MAURICE MORRISON
H. S. Mack
Geoffrey
Eleanor Gates
Robert Ryan
Sumner Getchel
Big Boy Williams
Arthur Heusman
FRANCIS MCDONALD
DE BRULLIER
HOWARD CRAMPTON
Hobart Henly
Michael Finnigan
SNITZ EDWARDS
JULANNE JOHNSTON
ANNA MAY WONG
WINTER-BLOSSOM
ETTA LEE
BRANDON HURST
TOTE DU CROW
SO-JIN
K. NAMBU
SADAKICHI HARTMANN
M. COMONT
SAM BAKER
Allan Boyd
Edward Cozen
Marie Thompson
Arthur Jasmina
Frederick Peters
Luis Dumar
FLORA PARKER DE HAVEN
CARTER DE HAVEN
HELEN HAYWARD
G.A. WILLIAMS
HARRY SCHUMM
Val Pawi
Will R. Walling
Mary Wilkinson
Julian Beaubian
Roger Brand
R. Henry Grey
Robert Weycross
Ernee Goodleigh
Habel Paige
Bill Potter
Louise Fasenda
"Baldy" Belmont
Isabelle Keep
Thomas Gillen
Sara Mullon
Charles DeForrest
Brian Danlevy
Bill Sellers
Germaine Morris
Bunny West
Claire Fenton
Thomas Fenton
Chouchou Rouselle
Sadie
Kempton Green
John Shermer
GEORGE STANLEY
NATALIE DE LONTAN
Mc
Thomas Sant-schi
Taylor German
Harvey
L. C. S
Perry
Robert Russell
Ed See
Howard Parrel
Nan Brenner
Jimmy Ford
Lucien Muratore
Edith Taliaferro
Homer Croy
Harry Keenan
SYDNEY LANE
MARY DIBLEY
LILIAN HALL-DAVIS
ALFRED PHILLIPS
MICHELIN POTOUS
MARGUERITE BLANCHE
J. M. WRIGHT
SID JAY
MANSELL FANE
M. CROMMELYNCK
F. ADAIR
FERNAND LEANE
R. SCOTT
M. ALBANESI
H. H. YOUNG
J. McMAHON
BERNARD VAUGHAN
JUNE CARROL
RAYMOND BENSON
Montgomery Stagg
Margery Stone
Ellen Brown
Gibson
Mrs. Stone
the young actor who takes the part of George
Bruce McRae
Tom McGrath
Lillian Page
Victor Beniot
Geo. Yield
Raymond Duncan
George Egan and Charles Leonard
Benny Leonard
Donald Mc Bride
William Barlow, Jr.
Kathlcen Myers
Tom Kermedy
William Walling
William Nestell
Charlie Brinley
BILLIE REEVES
John Fairmedow
Jack Flack
William J. Dyer
Harry Tenbrook
Zala Davis
Joe Rivers
Joseph Daily
Jean Fraser
Etna Ross
Vivian Osborne
Cerrine Barker
Edith Ralston
John Allison
Mrs. Gaynor
Harold Spencer
Samuel Ralston
AUSTIN CONROY
Shirley O’Hara
Ivy Harris
Nicholas Soussanin
Henry Delaney
James Mortimer
Blanche Griswold
Bert Harmer
Fay Muskley
Ursula Holt
Byron Thornburg
Delia Trombley
Dwight Wiman
Nona Marden
BILLIE BURKE
Helen T. Tracy
Frank Taylor
Ann Hunniwell
Helen Weir
David Proctor
Augustus Dalfour
Mack Barnes
Lew Hendricks
Walter Bussel
Jeanne Dolbert
Dick Grant
George Magrill
AUSTON
GRACE JOHNSON
JIM MASON
GRACE THOMSON
SIS MATTHEWS
JENNIE HARRIS
LOUIS BENNISON
Alphonse Ethier
Anita Cortez
Louise Brownell
MME. SARAH BERNHARDT
Louis Tellegin
M. Maxudian
Mlle. Romain
Mme. Boulanger
M. Durozat
M. Denenbourg
M. Piron
James P. Mason
Alice Marc
Phillip Grey
Golda Caldwell
Fannie Perkins
Miss Gerard Alexander
King Bagg
Schuyler Armitage
Giulia
Gaetanio Marco Arlani
Bilhe Rhodes
HILDA WILSON
HARRIS DOREYN
ADELE RAINEY
BLINK MORAN
WILL HARPER
ED JOHNSON
KID MCCOY
ALBERT RAY
DELL BOONE
RUTH MAURICE
HARRY TENBROOK
JAMES NEIL
EDITH WYNNE MATHISON
Mary Beth Mifford
Alec B. Francia
Pauline Truce
Chas. Crockett
Frederic Peters
Daddy Hoosier
Dolly Davis
Mlle. Forzane
Henry Krauss
Gaston Jacquet
Lucien Legay
Pierre Magnier
Jane Fearnleu
Miss Hunter
Miss Wierman
Thea
Clementine
Lais
George McKenzie
VIRGINIA GRANT
BETH GRANT
HARRY GRANT
PHILIP GRANT
HUGH MOREY
JACK MOREY
SILAS LACEY
HARVEY LACEY
DIXIE CARR
Charles J. Ross
Nicolas Suneaw (Eskimo)
James Ryley
Richard Wells Sr.
William E Lawrence
Myrtle Tichell
Conlin Kenny
Jean Codrae
Nina Burdock
John Burdock
Robert Wilkins
Mr. Delmar
Oliver N. Hardy
Fred Spence
Harry Tenbrooks
L. J. O’Connor
Grace Woods
The Dog
The Horse
Roxane Bellaîrs
Charles Dyer
JACK WALTERS
BERENICE SUMMERS
EVA MEYER
MRS. WITTING
WM. HONG
Harry Randall
Dot Grey
Alice ArdelI
Marion Weirman
L. W. Steers
Eleanor Hancock
Pearl Lovci
Lucy Manley
Marie Higgins
Ted Gordon
Madeline Woods
Gerald Harper
Tom Dilley
Leon P. Gendron
Ralph Bunker
Florence Martin
Frank Badgley
America Cheddister
John Mayer
John Washburn
T. A. Braidon
Ada Neville
Emma Wilcox
May Dorsey
J. A. Morley
Carrie Daumerey
Baldy Belmont
Michael Pretherson
Moya Flanbaugh
Geo. Flanbaugh
Ralph Sapson
Henriette Mallet
Louisa Ruder
Mr. Carrouge
Frank Hawley
Kewpie" Morgan
T. Moreno
Al Richmond
Art Winkler
Harry Belmour
Charles Bartlett
Ralph Cummings
Mona Darkfeather
Arthur Ortega
Gene Tunney
Wm Carr
Edward Abbot
Thelma Hihl
Danny O'shea
Harry TenBrook
ALICE CALHOUN
ROSSELL FORD
ADRIENNE KROELL
Mary Burton
Tom Ashton
Allan Sears
Edgar Sherrod
Mazie Darnton
Rev. Jonathan Meek
Bullato
Smiley Dodd
Mrs. Shamfeller
Mrs. Bump
Johnnie Bump
Jerry McKeen
Willie Shamfeller
Law Cody
D. Ahren
Mrs. Wright
John Starling
Dorothy Clark
Jason Foley
Giles Luther
Cora Foley
Elsie Foley
Mr. Lauderdale Maitland
Mr. Fred Morgan
Mr. Allan Wilkie
Mr. J. T. Macmillan
Mr. Fred Ingram
Mr. Norman Leyland
Mr. Henry Lonsdale
Mr. Frank Harvey
Miss Nancy Bevington
Mr. E. Warburton
Mr. Hubert Carter
Miss Ethel Bracewell
Alberta Vaughan
Shirley O'Hara
FAIRE BINNEY
William (Buster) Collier, Jr.
J.P. McGowan
Lottie Williams
Wm. McCormick
Dan Peterson
DAVID BUTLER
JOHNNIE COOKE
CHARLOTTE WOODS
BOB BISHOP
KEN MAYNARD
MARY BURTON
JOE BENNETT
CHARLES HILLS MAILES
BEN CORBERT
MONTE MONTAGUE
Otto Myers
Jack Pearce
Mary Louise Montague
BARBARA KING
ROBERT GRAY
Mr. Arnold Daly
Philip Nolan
Charles E. Graham
Duncan Mc Rae
P. R. Scammon
Marie Du Chette
Mrs. Mary Kennison Carr
Thomas Donnelly
Edward Dunn
Claude Cooper
Gerald Day
Frank Murray
Frederick Herzog
F. C. Earle
Frederick Truesdale
Jack Hamilton
Richard Wongemann
Helen Mulholland
“Baby” Carr
Sam B. Hardy
Walter Kirkwood
William Parke
Clio St. Bau
Ann Eggleston
Jack McLean
Julie Dempsey
Tcmmy West
Cameron C. Coffey
Jane Miller
LE GAGE
MALCOLM BLEVINS
Myrtle Steadman
John Drumier
Marie Lavarre
Fred Harnett
John Gray
Bateese Le Blanc
Jane Acker
Ruth Ashby
Sidney Carlyle
Ben Rivers
Mabel Grant
Jim Ruther
Ed Wenders
M. de la Parelle
Louis Fitz Rey
Art Accord
A. G. Kenyon
Carl von Schiller
John F. Connelly
Jack Conway
Bruce Eytinge
Inex Shannon
Robert Forsyth
Katherine Johnston
Irma Dale
Nellie Goodwin
Monty Price
JACK LEFTINGTON
GWENDOLYN
Lisa
John Standing
Viols Dana
Warren Chandler
Priestley Morrison
Robert Gaillard
DE MAX
Huguette DUFLOS
Walter Newman
Lyn Harding
Ruth Shepley
Ernest Glendenning
Arthur Forrest
Johnny Dooley
William Kent
Guy Coombes
LAFAYETTE MCKEE
Edwd. Sloman
Miss Barbara Tennant
Miss Julia Stuart
Miss Goodstadt
GRACE VILLERS
WM. ELMER
ROBT. McKIM
MELBOURNE MacDOWELL
CHARLES PERLEY
LEOTA LORRAINE
Robert Eliott
M. F. Titus
Algernon Dovey
Clyde Bensen
Miss Ella Hall
Kinglesy Benedict
Georgia Davey
Patricia Fox
Jeremiah Fogie
Herbert Fortier Butler—Wm. H. Turner
J.E. Williamson
Richard Ross
Asa Cassidy
Lulu McGrath
J. Rescher
Jeanne McPherson
Dick LeStrange
Tex Driscoll
John Ortego
James Griswold
Wilma Wild
Mary Vaughn
Genevieve Knapp
Yale Bopner
Charles Cotton
Marie La Hanne
James Clifford
Wm. Calhoun
Wm. Heck
Alida Astaire
Fred Harrington
Bryce Cardigan
Shirley Pennington
Buck Ogilvy
John Cardigan
Phil Brady
John Mason
Anne Luther
Katherine Perry
Bob Kertman
Gabe Price
AL MAC QUARRIE
Eileen Seagwick
Constance Keener
BUD NOBLE
A. G. DOW
Olaf Olson
Lou-Tellegen
Charles H? Mailes
Lucille Rickson
Allan Cavin
Max Weatherwax
Harry Bytings
FRD THOMSON
JACQUELINE GADSON
DAVID DUNBAR
BETTY SCOTT
DAVID "RED" KIRBY
Raymond J. Binder
Earnest Maupain
Julius A. Mood, Jr.
Duncan McRee
INEZ McDONALD
Joe Regan
Alicia Davidson
Mr. Radcliffe Davidson
Mrs. Radcliffe Davidson
Marmalade Zaidlaw
Harvey Phillips
Tapica
J.B. Jones
Bert Williams
Charles Griffith
CHRISTINE LESLEY
PAGE PETERS
Tryone Powers
Edith Hallor
Jack Bohn
Margaret Sedden
Henry Morey
Irene Delroy
George Storey
John Saimpolis
W.S. McDonough
Harry C. Brown
Irving Brooks
Sir Christopher Madgwick
Mario LaCorio
Mith Strickland
Jimmie Long
Tom Tulliver
Bessie Benton
Molly Long
Robert Lowing
Henry James
Duke Pelzer
HARRY DEPP
E.J. RATCLIFFE
ARLEEN HACKETT
LEWIS EDGARD
Ernest Haupain
Thomas Tomlinson
Clare Booth
Tramps
Uarda Lamont
CHARLES MAUDE
WYNDHAM GUISE
JOHN EAST
REGINALD DAVIS
F. BINNINGTON
C. M. YORK
CLAIRE PAUNCEFORT
YOLANDE MAY
LILLIAN LOGAN
Nellie Grant Mitchell
Eldine Stewart
Jane Talent
Alice Masters
Vinifred Greenwood
L. L. Hall
Jerry Hevener
J. F. Briscoe
Ruby Marshall
Philip Baldwin
Marjorie
Mrs. Grotenberg
Wilbur Lansing
Gertrude Bennett
Bill Hardluck
Joe Inright
Leila Hughes
Jeanne Hathaway
Tom Duane
Clay Wimburn
GERALD LAWRENCE
FRED MORGAN
GREGORY SCOTT
BRIAN POWLEY
DOUGLAS PAYNE
DOUGLAS COX
BRIAN DALY
DAISY CORDELL
MERCY HATTON
JOAN RITZ
MAY LYN
Charles J. L. Mayne
Bert Spofonte
Eddie Cliquot
Lee Young
Edith Pill
Mrs. Van Doren
Mr. Garat
Mr. Jacques de Feraudy
WALTER PIDGEON
SIDNEY BRACY
SAILOR SHARKEY
LLOYD WHITLOCK
Charles Alexander
James O'Shea
Cynthia Kellogg
Francis MacDonal
Rhy Darby
Liliam Leighton
Adele Blood
Jack Halliday
Arnold Lucey
Edna Goodrich
Lucille Taft
Miss Dora Adams
William Wolcott
P. Tamato
Fay Lanphier
William B. Mack
W. T. Benda
Alan Jeayes
George Power
BOB LENNOX
Jake Benner
Ethel Brush
John Webb Dillon
Lelia Crofton
Bert Bushy
John Ridgway
Margaret Wall
Bill Blaisdel
Richard Neal
Edward Bailey
HENRIETTA CROSSMAN
JACK WILSON
SYLVIA ASHTON
Beautiful Rita Jolivet
Michael Clancy
Bridget
Terry Ragen
Paddy Dillon
Gal Henry
EUGENE O'BRIEN
Helen Rogers
Freddy Tripp
The Widow
Mrs. Rogers
The Guest
The Colonel
Roger Malcolm
Carleton Macy
C. Chichester
BOB COLLINS
VIOLET FORD
HECTOR LORAIN
MRS. FORD
MR. GREENBERG
Martha Madison
Rod La Rock
Mae McAdoy
George Ransdell
Carlos & Jeanette
Ned A. Sparks
Jack Russell
Mary Kendall
Heida Loe
Mrs. Sterling
IRENE WALLACE
Glenn Anders
Jackson Read
Fred G. Becker
William Carleton
J. Johnson
Jack Prescott
Jack Bramall
Beatrice Fairfax
Henry Hanson
Mrs. Hansen
Paula White
Downing Clark
Mrs. David Landau
William E. Park
Ray Gray
Sheridan Tousey
Thomas Bradford
Cornelia Callahan
Edith Korellis
Henry Calverly
Mary Newcomb
Sam J. Ryan
RUTH DARRELL
JOHN LORD
Jane Lord
Herbert Lyle
John Banks
Mary
Henry Cole
George Robbins
Crimmons & Gore
WILLIAM WEST
WILLIAM BECHTEL
YALE BENNER
WALTER EDWIN
Edward Cossen
Antonio Sartori
Paula Sartori
Duncan Macrae
Francis Marion
L. De Noskoski
Lillian Hall Davis
Alphons Fryland
Bruto Castellani
Elga Brink
Elena Di Sangro
Ginao Viotti
R. Van Riel
Rina De Liguoro
Ralph Warner
Geraldine Blair
Reginald Simpson
Stanley W. Waipole
MISS MARY UNDERDOWN
MR. ROY TRAVERS
MISS LILIAN HALL-DAVIS
MISS ISOBEL ELSOM
MISS DOROTHY MINTO
MR. CAMPBELL GULLAN
MR. JAMES LINDSAY
MR. TOM REYNOLDS
MR. HUBERT CARTER
MR. ALLAN AYNESWORTH
MR. WYNDHAM GUISE
MR. FRED LEWIS
MR. TILSON CHOWNE
MICKY BRANTFORD
JOHN BRANTFORD
Frederick Cavendish
John Cavendish
Jim Westcott
Leonard Ciapham
Justine Spencer
W.P. Carleton
Billy Ferris
Randolph Ferguson
Oliver Ferris
Loti
Ellen Olson
George Andre Beranger
Randolph Sterling
Cleo Loring
Ed Armstrong
Gene Jarvis
WM. WELSH
GRACE MAC-CLEAN
S. ZELIF
Ilsa de Lindt
L.C. Shurway
LYDIA YEAMANS TITUS
MARC FENTON
GEORGIA FRENCH
T. D. CRITTENTEN
Frank Harris
Charles Hatton
Queenie
Baby Gloria Wood
Margaret Wiggins
May Rogers
Shaw Lovett
Mrs. Craig
Warda How
Edmund F. Co.
Alice Lambert
Grant Lewis
Mrs. Henry Beresford
Mrs. Gordon Howe
Mrs. Dunn
Parsons
David Leighton
Ruth Beresford
George B. Williams
Will Badger
Eleanor
Gordon Murra
Sally O’Neill
Harlan William Haines
Ted Ford Sterling
Valli Valli
William Nigh
David H. Thompson
R. A. Bresee
Jack Murray
Lucius Henderson
Robert Landy
Laura Bicknell
Virginia Merrill
Mary Maurice
Edwina Robbins
Phil Marquardt
Hy. A. Barrows
Robert Carter
Wm. Chester
Jim Younger
ANN DICKSON
CAREY PHELAN
"HAPPY FLANIGAN"
FREDERICK PIERSON
JAMES DICKSON
ELLEN DICKSON
MADAME OHNET
CHIEF MORGAN
William Crombie
Hurt Kilstrom
Jack Corona
Mrs. C. J. Williams
Reginald Newman
Arline Coughlin
Karl
Joseph
CARTER HOLMES
RUTH STANHOPE
Earl Mohan
Jce King
Helen Tracy
Fritzi Ridgway
Vida Ramon
Martin O'Neill
Gudrun Trygavson
Laura Lavarnie
Jacob Tiedtke
Mady Christians
Carl Beckersachs
Julius Falkenstein
Mathilda Sussin
Xenia Desni
Lydia Potechina
Malcomb Blevins
LOUISE HUFF
LEO HOUCK
undefined
Frank Beal
Cleve Moore
BLISS MILFORD
EDWARD BOULDEN
CONSTANCE JOHNSON, EDNA JOHNSON
ELEANOR GOODSPEED
ELIZABETH CONWAY
Walter Stoddard
Steve Rowe
Jane Godfrey
Rich MacAllister
Charles Insley
Gertrude Douglas
Kate Wiggin
Slick Freeman
Reddy
Victor LeRoy
Janet Besson
Lew Roget
Benson
Robert Pettie
Mollie Nixon
Harry Tembrook
S. BARCLAY
Art Courier
Lilian Hackett
Barry O'Connor
Patrick O'Connor
Mary O'Connor
William Tompkins
Reggie Vanderlip
Father O'Toole
Housekeeper
FRED EUGENE WALSH
ELSIE JANE WILSON
COUNT VILLE HANORY
DANIEL CHAMPEY
ROBERT HENLEY
C.N. HARMOND
ANTONIO MORENO
George H. Reed
Nenette DeCourcy
H. O. Barrows
Janice Peters
Cleo Ridgley
Isabelle Garrison
Hubert Brown
Kathryn Hildreth
Miss Johnstone
Dan Wallace
Olga Strogoff
Herbert Wood
Julia Dale
CLIFF REDFERN
NED CALDWELL
FREDERICK VROOM
GUNNER MCCANN
ALFRED FERGUSON
Dorothy King
Robert Daley
Clarence Heritage
Thomas Tommamato
Leon de la Mothe
Buck Conlon
Bull Barrett
Parson Rhodes
Molly Rhodes
M RIAN SKINNER
TOM DUNSTAN
ESTHER WHITAKER
CALEB TILDEN
AARON WHITAKER
EBEN WIGGS
GEO. HERNANDEZ
JACOB BABCOCK
John Jarrott
E. M. Keller
Tony Jeanette
Nell Bennett
Evelyn Nesbit
Clifford Cole
David Doyle
Ned
Wm. Davids
Clare DuBrey
Lamar Johnston
Louis Sterne
John Rutherford
E. Emerson
E. Hornbostell
Phyllis Allen
Patsy De Forrest
Billy Fay
Harvey Hanford
Mary Cameron
Richard Raver
Dr. Harvey Tyson
Clifton Allison
Ed Martin
Ethel
Vera Stanford
Beatrice le Plante
John Underhill
Warren Goodwright
Una Trevelyn
John Nichols
David Miller
Ted Miller
Anita
Joseph Bansome
WM. FRANEY
MILBURN MORANTI
Darby Foster
Lillian Douglas
Nina Boucicault
Haidee Wright
Marie Wright
Sir Simeon Stuart
Mildred Evelyn
Bernard Vaughan
John and Casey
GEORGE ARLIS
TAYLOR HOMMES
IVAN SIMPSON
JOSEPH DONOHUE
REDFIELD CLARKE
WALTER HOWE
WILLIAM SELLERY
GEORGE HENRY
Ruth Clifofrd
Bob Perry
Emery Bronte
J.W. Johnston
Miss Foster
Edward Flanagan
James Cooley
Minna Phillips
Claudette Colbert
Richard Skeets Gallagher
Rudolph Cameron
Mabel Swor
Blanche Pays n
Kaj Gynt
J. Van Cortlandt
Keenan
LUCRETIA HARRIS
MARY LAND
Rodney Lane
Evelyn Gilbert
Wheeler
Miss Du Pont
Miss Drew
Ruth Van
Earl Weston
Wilson Hummel
Victor Rodman
John St. Polis
Cora Gertz
Tom Coulahan
Lydia Yeamann Titus
Paul Dorfeuil
Mlle. Renée Sylvaire
Mr. Charles Krauss
Mlle. Josette Androit
Harry McDonald
Jean Forsythe
Zanhagar
Meccham
Willard Wright…………Ben Wilson
Joe Cullison
HENRY B. WALTHALL
HELEN WHITMAN
Eleanor Thompson
Peggy Meredith
Harrison Craig
H. I. J.
Manuel Cameré
HARRY MC COY
Olive Mix
Capt. Charles Nungesser
ELITINE GIRARDOT
LOUIS FRIEDLANDER
Al Walling
Aggie Herron
Phil Ford
William Brooks
Sam Sothern
Grace Elliston
Frank Hannah
Edwin Polk
Del Lewis
David Winter
Jean Dumont
Harry O’Conner
Dolores Casanelli
Barbara Dean
Neil Roy Buck
Charles Eaton
Allen Earle
Martha McGraw
Margaret Foster
Dorothea
Ned Benton
Bill Nye
Henry Alswell
Edgar Murray
Charles W. Stevenson
Vinton Friedley
Regina Quinn
Eddie Maloney
Carl Russell
Frank Carey
RAYMOND MCKEE
BRUCE GORDON
James Conley
E.W.Borman
Rona Lee
Paul Weigle
Lucille Thorndyke
Barry West
Nicholas Lanza
Edna Helmi
Janet Davy
Mildred Peters
Ambyro Hamel
Dick Fear
JUAN DE LA CRUZ
J. FRANK GLENDON
HELENE SULLIVAN
PAULA MERRITT
MAUDE EMERY
ED.M. KIMBALL
Victor Steele
Robert Lee Keeling
J.H. Colby
Edythe Roberts
John Goody
Bessie Toner
Jonathan Small
Dave Stewart
Betty Channing
Red
Milt Uhl
Starton Heck
Miriam MacDonald
"Shorty" Hendricks
Andy Morris
Rev. Keith Rollins
Corn Drew
Lassie Young
FLORRIE LEVERE
LOU HANDMAN
Jno.P.Lockney
Chas.Spere
Mrs. Wallace Brokine
Harry Cornell
Edward Hartle
Yale Banner (Bliss Milford)
Allen Crolius (Saul Harrison)
Violet Marcel
Miss Vera Rial
Conrad Cantzen
Lawrence Grossmith
Charles Blackton and Violet Blackton
Philip Van Lorn
Mlle. Marcel
Julia Arthur
Irene Castle
Paul Granville
Syn de Conde
Philip Sandford
True James
Dave Turner
A.C. Hadley
Thelma Von Styne
Albertt Jensen
Etienne Hilaire
Diane Laurens
Alphonse Laurens
Arthur Remsen
Natli Barr
Fred E. Nankivel
Edna Hammel
Maige Evans
Edward Coten
Lester Le May
J. Cummings
Julia N. Stark
Gorfon Griffith
Althea Worthley
Frank Cook
Lou Salter
John McCallum
Bob Golden
Will Roberts
May Martin
Stephen Kopf
Wm. Bailey
LEONORE FIELDING
Stella Hammerstein
Ethel Winthrop
JULIETTE DAY
CHARLES BENNETT
LOUIS MORRISON
EMMA KLUGE
Henry Mortimer
Richard Barbee
George Pauncefort
William Cahill
Jeannette Horton
Ruth Chester
JANE BRETT
Tom Tempest
Frederick Chasten
Ray Chamberlin
Gerard Welden
Maud Barhyte
SHIRLEY MASON
RICHARD ARLEN
William H. Strauss
Harry Crocker
Frederick Perry
Dorothy Rogers
Marie Haines
Emmett Dalton
EMMETT DALTON
Ida Pardee
Mabel Bordine
Jack O'Loughlin
Dick Clark
Jennie Nelsen
Dorothy Duncan
Justin Arnold
Frank Jerome
Beach Cooke
Ray Thompson
Gus Bartrum
Tenor Vertner Saxton
Betty Howard
Thomas Mills
Marjorie O’Neill
Jack Fowler
Diana Laska
John Heppell
Janet Warren
John Wilbur
Harold King
George Probert
Mrs. Woodthorpe
Eileen Roberts
Ann Malone
Mlle. Dion
Miss Guwha
Mary Hatfield
Jack Walton
Bill Hatfield
Jim Calahan
Zena Virginia Keefe
Robert Keggerris
Maura Lambert
Ralph Delmore
Ray Pilcer
Glen Cavender\nGeorge Davis
I. Bernstein
Henry Merwin
Ann Booth
Mae Prestell
Geo. C. Pearce
Speck O'Donnell
Howell Autrim
Jeanie Mac Pherson
Viola Daniels
Rochard R. Neil
Walter Mailey
Victor Mazzetti
Samuel Weatherbee
William Burns
Steela Razeto
Charles Lyke
Fay Belasco
Jos. Harris
Rufe McCullough
Philip Duprey
Marcia Duprey
Gene Morgan
Miss Stella St.Audrie
Miss Jane Gail
Miss Christine Rayner
R. Judd Green
Marion Nixon
William Cooper
L. M. Horne
F. Gatanby Bell
JOHN BELMONT
ROSE
CLEO
JACK LAWLESS
Johnnie Jones
Miss June Keith
Alfred Gronell
Frank Wonderly
Miss Layton
Miss McDonald
Cirius Andrews
Henrick Ward
Jim Haley
Lyes Baily
Mabel Trumbelle
Yale Berner
Mrs. Wallace Franklin
CHRALES BRINLEY
Byron Thonberg
Reaves Bacon
Moonlight
Violet Malone
Eleanor Mason
Violet Azzell
Ida D.
Hubert Wilke
Charles Crompton
Robert Fisher
Ed Mauer
John Willington
Andy Murphy
Master Joseph Monahan
Miss Janethel Monahan
Miss Margaret Costello
Master Donald Costello
James A. Fitz-Patrick
George Brownlow
Glenn Kunkel
Nabel Dwight
Hans Junkerman
KATE KENNER
DAN DEERING
SILVER SPURS
ROBERT FLEMING
DOROTHY ABRIL
Simon Valjon
Mary Valjon
George Kimball
J. Edward Brown
Chas. Hammond
John R. Hope
Brooks McCloskey
Charles Ebbinger
Jack Lamb
Henry Dixon
Olive Dixon
Frank Bryce
May Latham
ANDREW WALDRON
THOS. LINGHAM
ADGAR ALLEN
Luciano Albertini
Violet Keller
Myrtle Gordon
Payne Winthrop
Corrine Lorimer
Barclay Seymour
Lydia Richards
Maria Richards
Robert North
Annette
Wm. Lynch
Yolande Brown
Jean Wilson
Isobel Franklin
Wesley Westbrook
Stanley Simmonds
NORMA HANSEN
JOSEPHINE PHILLIPS
Paula Blackton
Charles Stuart Blackton
Violet Blackton
Wellington Prater
Philip Carr
Carl von Haagen
Gretel von Haagen
Townsend
Ned Townsend
Charlie
Sam
Eitel von Haagen
Lydia Quaranta
Teresina Matangoni
Dante Testa
Umberto Mazzato
Ernesto Pagani
Italia Manzini
Vitale Destefano
James Bradbury, Sr.
Claud Buchanan
Thelda Kenvin
Dorothy Nourse
Greg Blackton
CORA CLAYTON
Carlotta De Felice
Antoinette Allen
Jimmy Bancroft
Dell Henderson
Amy Forrest
Doyle
DeForest
Henry Koser
Luke Simms
Richard Sears
Florida Everett
Nell Harter
Rodrique LaRocque
Robert Wesley
Geo. Gebhart
Bryon Douglas
Robert Cantiero
Minnie Danvers
J. N. McDowell
Kenneth Nordyke
Chester Randolph
Rev. Martin
Martin Lowe
Jacques Jaco
William Tedmarsh
James K. Hackett
Mabel Juliene Scott
Laura Sonderson
Louise Mackintosh
SARITA GRAVES
J. W. JOHNSTON
LOUISE MINEUGH
Alice Martin
Alonzo Greenwood
Louise Hester
Tom O'Day
Barry O'Day
Mary Redmond
La Due
Will Dozier
Elsie Dening
Edward Gray
Robert Chambers
Ruby L. KE
Doris Martin
Judd Martin
Steve Hools
Steve Hendricks
Pete Larkness
Bob Elwood
Clement Sauvresy
De Tremorel
Lecoq
Plantat
Mayor Courtois
Bertha
Laurence
Jenny Fancy
Edward Butler
Nigel de Brullier
Al
Lige Peters
NEAR HART
Jack Rollins
James Livingston
Dyane Thompson
Morgan Spencer
James Cuthbert
Ray Russel
Roger Carlin
Mary Truax
Richard Jelf
Gerald Ainley
Jerry Madden
Slim Whitaker
Molly Gilmore
Elsie Earl
Tokura Tsuda
Robert Renael
Clara Bracey
Jim Barrows
Tom L. Burnett
Bryan Roach
Ruth Roach
Tommy Kirnan
Bey Kirnan
Fog Horn Clancy
Hugh Strickland
Leonard Stroud
Grace MacLean
Eugene Owen
Besse Wharton
Beverly Davis
Emil Jennings
Ferdinand von Alter
Werner Kruss
Robert Scholz
Josef Runitsch
Charlotte Ander
Mala Delschaft
Hilde Werner
Chas. Kelly
May De Mets
Albert S. Hart
Olive Hasbrousk
Alberforce Jones
William Jones
Mrs. Emmons
CONFAD NAGEL
Frederic de Kovert
Rupert Ellston
Estelle Dalny
Bourne Carringford
Lopez Deligardo
Jacoba
Thos. J. Commerford
Tom O’Malley
Edna May Sperl
Lillian
Marion
Harry Edwards
William Barstow
Henry Morley
Geoffrey Patten
Jane Grayson
FRANK NEWBURG
MARGARET ALLEN
Myra Glazier
"Bob"Moultont
John T. Cossar
Fair Binney
Willette Kershaw
Joseph White
BOB DAVIS
FRANK SCOTT
MANUEL BACA
Mary Sinton
Lucy Sinton
Ralph Lee
Leah Graff
Herbert Horton Pattee
Wilson Bayley
Philip Sanford
Winnefred Greenwood
COE. MARTIN
Geo. L. Cox
Edward Harle
Idna Hamel
Gene Cowles
Robert Kegarrels
CALVERT PAIGE
JOHNNIE PAIGE
LIL MAGILL
Jay Brown
Betty Morrissey and Malvina Polo
Faith Markham
John Winslow
Joseph Butterworth
ALICE NEICE
MYRTLE GONZALEZ
GEORGE KUNKEL
OTTO LEDERER
King Fisher Jones
Richard Cumming
T.boy Barnes
Bob McKim
Silver King
Harry Harper
Starkey
Beverly West
Job Mordaunt
Guy Mordaunt
Frank Bonner
Capt. Ted. E. Duncan
Fred Turjer
Robert Brownley
Peter Brownley
Judge Lee Sands
Beulah Sands
Count Varneloff
Simone
Wm. Rhyno
Ray G. Watson
Miss Pickford
Bertram Marshall
D'Hara Marsden
Elsie Haynes
Miss Muriel Blythe
Freddie Needham
John Marsden
Davenport
Patrick O'Malley
Virginia Ross
Leel Stuart
Luis Frondi
Paul Machette
Henry Schaum
Sydney Seaward
Teddy Arundel
Dennis Neilson Terry
Patrick Kay
Ernita Lascelles
Joseph W. Gerard
Hector Mazzanti
David Thompson
Helen Alexander
Lillian Shaffner
Al Lee
Mrs. Breyer
Warner Anderson
Eddie Reddway
Daniel Bertona
Tom Jordan
Madge Van Zant
Burton Wilson
Frank Barry
Buster Keaton Jr
Kitty Bradbury
Ralph Bushman
Jean Dumas
James Duffy
Lucille Ruby
GEORGE F. MARION
Geraldine O'Brien
Steve Flanders
Richard Morgan
Edith St. Clair
Baby Morrison
VIOLET HEMING
David Wall
Nicholas Thompson
Mr. a"d
Mrs. Carter DeHaven
Ruth Corbin
Earl Stanhope
Steve Carr
T. Woodruff
Earl Edwards Davies
Martin T. Faust
Gloria Heller
Sidney De Grey
Alexander Girardi
Mabel Greene
W.H. Turner
Shirley Chamberlain
William Emerson
Don Calvert
Blanchita D'Acosta
Daniel Morgan
Henri Bergere
Barrington Barringer
Marcus Moriarty
Charles Hurtley
TRUMAN VAN DYKE
ELINOR FIELD
La Fayette MacKee
James Bradbury Jr.
Al Fremont
John North
Sweeney Bodin
JOHN EWING
HELEN EWING
JIM CALVERT
VAL HEYWOOD
TROVIO VALDEZ
Baby Dorothy Brock
Richard Taber
Frederick Wood
F. A. Wade
ESTHER CAREY
B. J. Hendrix
Dirk Kanset
Anne Kromann
Frank Wisely
Earl Marréson
Hobarth Bosworth
Wallace Brownlow
Robert Arnold
GEORGE LESLEY
RICHARD RIDGELY
Bob Armstrong
Marie Van Tassel
COURTENAY FOOTE
THELMA PERCY
CHANCE WARD
“DOC” CANNON
JACK CARLYSLE
DWIGHT CRITTENDEN
William Bevan
Katharine Harris Barrymore
Edward Abeles
Pauline Welch
Maggie Western
Nellie Parker-Spaulding
W. D. Fichter
J. F. McDonald
Barbara Maier
DeBriac Twins
LUCIANO ALBERTINI
Al. Roscoe
Chas. Walcott
Ann Egelston
James Fury
Damophilia Illington
Mario Bromo
Carolyn Wright
WALLACE MCDONALD
Mrs. Grassby
Hermann Thimig
GERTRUDE GREY
TOM CARRIGAN
GLORIA GALLOP
EDWIN WALLACK
EDW. J. PEIL
Tom Hardy
Robert Andersen
JOHNNY FOX
DAVID BRANT
HELEN BRANT
FRANK PEYTON
BABY BRANT
MAID
Mr. McDaniels
Edw. Martindel
Chas. Meredith
Eugenie Hoffman
Pelle Bennett
W. C. Miller
M. Wells
M. J. O'Neill
Arthur Cunningham
Nancy Squibs
Joseph "Chip" Monahan
Janethel Monahan
Max Moscowitz
Charles Cassi
Peter Barbara
Kenneth Gordon
Fritz Moscowitz
Dolores Mitrovich
Jack Paul
Geoffrey Challoner
Norman Craig
Margaret Shelby
Marie Morledge
Harold Vosburgh
Helen Wakefield
Jack Armston
Franzi Gunn
Art Staton
Hazel Hart
Floyd Talifarro
Edward Moncrief
WILLIAM FABLES
JAMES HARRIS
AMY DENNIS
FANNY COHEN
FRANK HAMILTON
A. FRANCIS LENZ
Henry Roquemore
JANE LEE
KATHERINE LEE
RUBY DE REMER
WILLIAM PIKE
HENRY CLIVE
EDWARD STURGIS
TAMMANY YOUNG
GEORGE HUMBERT
SARAH MCVIKER
ANN EGLESTON
Jack Bryson
James Fowler
A.H.Hallett
Sally McCree
Thos. Rooney
Nannie Mason
Thos Holyoke
Wm. Brewer
A. Weil
Harry De Moore
G. Guniss Davis
Bonnie Jean De Bard
Linda Ann Corlin
Harry Foy
Sybil Russell
Marjorie Hale
Bill Wallace
Helén Hale
Charles Hale
Gregg Mowbry
Clara Simmons
Atherton Bruce
Ruth Minchin
Richard Steel
Edward Langholm
William Gross
Emma Campbell
Nancy Hathaway
Agnes Wakefield
Jack W. Johnson
Henry Heaton
William T. Hayes
Catherine Thomas
W. Harcourt
Harry Kosher
Jay Lee Bean
Joseph Galbraith
“Heine” Conklin
Marise La Noue
Jean Leonnec
Bobo
Hugo Leonnec
Nana
D'Agut
Mama Bouchard
Papa Bouchard
Mme. Pousset
The Toad
Le Turc
Concierge
Eileen Huban
Ethel Durey
Augustino Borgato
Gustave von Seyffertitz
Cosmo Kyrle Bellew
Rozita Marstine
Paul Bourgeois
William Garivood
Stella Razeta
Josephine Miller
Bertha Kent
W. H. Bachman
George Q'Hara
tenry McBride
Fra Irving
Bryan
Maud Clifford
Pasqualina de Vow
Donald McNamar
Hugh Thornley
Martin Hobart
Virginie De Valerie
Inez Alvarado
Page Ulrich
Dolores Alvarado
Bob Duncan
Prof. Raymond Alvarado
Edward Mawson
Renee Clemons
Al Barzan
“Daddy” Manley
Mrs. Manley
Adoni Fovieri
Sonny McKeane
Charles B. Crockett
H + Standing
N Kelso
A Selwynne
Billy Lyons
Emma Lyons
Elsie Lyons
John Wyman
BILLIE WEST
CHESTER WITHEY
Eleanor Ferrol
Geoffrey Harland
Eddie Boland, Buck Connors
Gladys McConnell
Frederick Stanton
William H. Brown
Dave Kershow
Vitaphone Symphony Orchestra, Herman Heller
James Mordon
Henry Penrose
Herbert Manning
George Ingleton
Robert B. Mantell, Jr.
Harry Weir
Dorothy Fairchild
Chas. Wellesley
J. Blake
Lucille Warde
Harry Lorein
Marion Heath
Fred Ransom
Mr. Heath
Andrew Tavish
Effie Shanon
Henrietta Crosman
Isaac Ben Orman
Fanny Lawson
John Cross
Fergus McManus
Stephen King
Claudia Lawson
Azray Heath
Isadore Eldagardo
W. A. Oriamond
PHYLLIS HAVER
MAJORIE GAY
Frances Wadsworth
Malcolm Dale
Crandall Park
Mollie Rourke
Rockaway Smith
Sally Smith
Maurice Remard
Rosebud Miller
Eddie the Pup
V. Toncray
Florence Wellington
J. F. Conley
Joan Converse
Jeffrey Dwyer
Inez Martin
Bruce Covington
MISS ALMA HINDING
Lamor Johnstone
Violet Mac Millan
Gloria O'Hara
Allen Brooks
Bud Jamieson
Jimmy Ambrey
ROY Summers
SALLY O'NEIL
ESTELLE CLARK
DeWITT JENNINGS
ETHEL WALES
JOHNNIE FOX
DOROTHY SEAY
EVELYN PEIRCE
HELEN HOGE
BRINSLEY SHAW
Will Herford
Kamuela Searles
Fanny Midgely
JOHN NEVILL
BEATRICE FARLEY
HERBERT BARRINGTON
Peter Armitage
Rose Gray
Jed
Vabel Van Buren
Myrta Sterling
Ethel Dayton
Mary Taylor
William Harvey
BYRON BENNETT
Radcliffe Fellows
Marjorie Milton
Lillian Worth
Charles Whittaker
Bess Murphy
Dorothy Drake
Frederick Montague
LUCILLE YOUNG
LUCILE LAVARNEY
Hettie Grant
W. M. Sturgeon
Vernon Rickard
Dorothy Appleby
Margie Evans
Jack Egan
Avis Seabury
Ruth Hampton
Akka
HENRY MURDOCK
later Steve Hogan
Jasper Rogeef
Carter de Haven
JEANNE LABORDIE
JACQUES LABORDIE
TALIAFERRO
Donald Duncan
H. P. Webber
Louis Hebert
Georgianna Lane
Hope Van Alen
Gerald Pownes
Anthony Van Alen
Evans
Dr. Mache
Dr. Pope
Harmon Hicks
Ralph MacComas
Charles Mackay
Lois Ingraham
Theda Bara
Jas. Marcus
Lillian Hathaway
Carl Harbaugh
Nan Carter
Thos. West
Leah Wyant
Bernice Frank
Jack Diumier
Reginald Sheffield
ANN MURDOCK
KATHRYN CALVERT
Richard Hatteras
Herbert Ayling
V. L. Granville
H. Ashton Tonge
CHARLES HAMPDEN
KATE SERGEANTSON
ZOLA TALMA
MAUD ANDREW
Gable Henry
Mme. Ganna Walska
William Yearance
Elizabeth Le Roy
Mona Lisa
Vincent Clive
Chas. Rock
A. Holmes-Gore
Dorothea Wolbert
DELIGHT WARREN
MICHAEL BALSIC
JACK McCARTY
DANİLO LESENDRA
AL. ERNEST GARCIA
GERTRUDE KELLAR
Arthur Thallasso
Frank Jonnasson
ABBY LOU MAYNARD
RICHARD COBB
TOM COBB
JOSEPH SNOW
MRS. ROLLINS
PERCIVAL ROLLINS
MARGUERITE D'ARCY
MACE
Milton Rosmer
Irene Foster
Bettina Campbell
Daisy Campbell
Gerald McCarthy
Olaf Hutten
James G. Butt
Leonard Robson
George Travers
Thomas E. Montagu-Thacker
Jesamine Rogers
Duncan Reed
Otto Mattiesen
Walter Merrill
Jack Kerrigan
KATHERINE MacDONALD
Brenda Fowler
Peter Duffer
Dominica Meduna
H. M. Best
Art Rowlands
OWEN MOORE
Alice Gardner
VOLA VALE
MacDowell
Lola Todd
Wm. Machin
Marshal Neilan
Raymond Blathwayt
F. E. Butler
Berry O'Moore
Kenneth Lawlor
Ruth Baird
Enoch Morrison
Dave Hatfield
Cameron Hatfield
Cosmo Hatfield
Peter Morrison
“Spike” Dugan
Dan Moran
Nellie Moran
Mrs. Walker
Charles Raven
Julien Beaubien
PHILo McCULLOUGH
Vincent Berresford
Leon Folsom
Seth Oaksheaf
ANN REID
PERCIVAL TERWILLER
TED VANE
DOLLY
BALVINI
Ruth Strong
Makum Strong
Mark Tyme
John Grant
Agostino Borgato
Maude Truax
Raymond Van Sickle
Brandsby Mordant
Jeremiah Pew
Herbert Grodney
James Crowley
Adolph Gassner
Phineas Glenister
Jefferson Armstrong
Marie Marat
Dorothy Glenister
Richard Armstrong
Alexander Greggson
Gladys Tennison
Benn Travers
DOROTHY DUNBAR
GARDNER JAMES
JOHN MILJAN
EDWARDS DAVIS
HERBERT GRIMWOOD
GINO CORRADO
SIDNEY de GRAY
JOHN PETERS
Bill Grimm
Jack Fairfax
Butch Ford
Left Hook O'Brien
Pansy Pilkinton
Cameron Coffey
Arthur Witting
Rébert Connness
Kay Deslys
Frank Reichler
C. AUBREY SMITH
HOLMAN CLARK
Mary Murdock
James A. Furey
Craig Winchell
Clara Marshall
John Winchell
Lawrence Johnston
Venita Gould
Begelow Cooper
Youcca Troubetzkoy
Al Cassidy
Selma Larson
Aaron Savage
Adrienne
Maggie’s Dream Lover
Frances White
Roger Van Horn
Bobby
Warren Hadley
Paul Thompson
Fay
Diamond Tights Girl
Frisco
Mr Gallagher
Mr. Shean
Eddie Cantor
Sammie Burns
Katharine Griffith
Katherine McIlonald
Nobel Trunnells
Drew Martin
Nobel Dwight
Jessie Stevens\n(Lou Gorey)
Barney Sherry
Iolores del Rio
Hamilton Morse
Alice Nichols
Alice Belcher
VALESKA SURATT
Chas. H. Martin
Alec Shannon
Joe Higgins
Daisy Bunding
James Bunding
Marcel Philippe
Lilian Delorne
Jermyn Garston
Geo. Soule
CORMACK O'DONOVAN
GWENDOLYN O'DONOVAN
J. B. O'DONOVAN
H. HOLLAND
B. GRASSBY
Lillian Mason
William Lesta
Bell Mitchell
Carrie Fowler
Fred Koler
KAREN WOODRUFF
MISS EDITH CRAIG
EDWIN DREW
J. Belasco
Clair McDowell
C. G. Briden
Harry Devere
Thomas Bates
James Ellison
Irene Blackwell
Max Willink
Jack Earle
Claire Bennett
Madge Saunders
George Fuller
Alfred Vosburg
M. Everett
Chas. H. Mailes
Robert Cheney
Mrs. Cheney
Kathleen
Kenneth Post
Jean Hardy
Paul Dustin
Lucille Crallen
Drake Dunn
SUSIE NOLAN
PHIL BURNHAM
SCHWARTZ
JIM NOLAN, JR.
LIZZIE NOLAN
JIM NOLAN, SR.
JOHN BURTON
JACK NELSON
PAULINE PERRY
CHRIS LYNTON
Matheson Lang
Hilda Bailey
Ivar Novelle
Duchess D’Ansois
Twinkles Hunter
Marge Kennedy
MISS DU PONT
Jack Pervin
Ralph Ashton
Rossett Van Nott
Charles Krauss
Willie Gibbons
Nancy Bradshaw
Earl Whitlock
Lila Grant
Ellen Wilmot
Oliver Barnitz
Jacob Wilmot
The Hon. Peter Barnitz
David Houston
Galdys Tennyson
Geo. Howard
John Steele
Donna Inez
Milton Manning
Anna Brody
Victor Gilbert
Louise 'Lovely'
MARCELINE DAY
WARD CRANE
Charles Hamlin
Jennie Stewart
Olive Pringle
Larry Trelawney
Anna Morrison
Larry Fisher
H.C. Simmons
Elinor Vanderveer
Byron Sage
Marcel Corday
Maj.Gen. Michael Pleschkoff
Alan Sears
Frank Conlan
Bill Smith
William Donovan
Fat Karr
Manuel Leon
Miss Nancy Deaver
Saxon Kling
Miss Hazel Washburn
William Thompson
Mortimer Snow
Miss Myrtle Morse
Charles M. Seay
Florence K. Lee
Karl Stockdale
Miss Myrtle Gonzalez
Marjorie Wilson
Albert Wilson
Frank Fitzgerald
King Baggot and Leah Baird
Katherine Mac Donald
Katherine Criffith
ANNABEL COTTEN
Jack Mortimer
Willie St. John
Colin Henney
Stanley Brentwood
June Lathrop
Rupert Spaulding
John Henshaw
Carl Sauerman
Edwin Denison
Clarette Clare
John T. Dwyer
Margaret Fielding
Jessie Gill
N. B. Bonner
C. H. Devere
H. B. Schlosser
Lon Poff, Eugenie Besserer, Edwards Davis, Carrie Clark Ward, Baby Billie Jean Phyllis
Rosina Henley
Nicholas Long
Frances Miller
Janet Vernon
Joy Farnsworth
Edward Martin
Walter Richardson
Vida Johnson
Charley Murphy
ELSIE MOORE
Little Steve
Steve O'Mara
Caleb Hunter
Archie Wickersham
George Kline
Marie Edith Wells
Ted Dean
VIGEA DANA
Walter Clinton
Sam Green
Frank Elliot
Miss Soberanes
Rita Stanwood
Betty Jonson
Jode Mullally
J. N. Burton
J. W. Johnson
Rockliffe Fellows
John Adrizonia
John Dungan
Maggie Quick
Eva Bundy
Amilo Rodolpho
Jas. Montgomery Johnson
Betty Hazelton
Hollie Grant
Ford Fernimore
Billie Ruge
Morris McHugh
Bert Allen
Willie Higgins
Speedy Smith
David Roseborough
Edward H. Ford
Andre Lenoy
William Farnum
Dawn O’Day
Barlowe Borland
Norman Manning
Gypsy Abbott
Dorothy Oliver
Otto Meyers
J. M. Foster
Ted Brooke
Ed. Price
Patsy Murray
Charles Michelson
Bernice Chelmsford
Tony Tafoya
Buu McNight
Harry Thompson
Henry Thompson
Justice Higgins
Widow Hull
Gene Corrado
Isabelle Keith
William NortonBailey
Clairette Clair
Lucile Ames
Jack Harding
Mr. Ames
Stafford Pemberton
John Deering
Nick Wells
Hans Kraus
Broerken Christians
J.A. Murphy
Pete Bell
H. Rice
Fred O'Beck, Cliff Salm, Henry Murdock, Charlie Sullivan, John Kolb, Al Alborn
Jack Rigeway
George F. Marion
George F. Cooper
H.I. HOLLAND
GIRRARD ALEXANDER
Frank Dane
Walter Palm
Nat Pendleton
G. W. Hall
George Pelzer
Arthur Ludwig
Harold McArthur
Adolf Link
Jerry Sinclair
Dick Lee
Elsie Albert
Denny Mack
Deacon Barnwell
Nick Dowd
Stephen Collins
George Herman
LeRoy Madison
John Brocton
J. Norris Foster
J. Webster Dill
M. W. Testa
Frank Frayne
Robert Eaton
Frank Ford
Lorna Volare
Miss Castle
Ernest Gillen
Thelma Morgan
John Morgan
CHARLES B. MURPHY
DAVID STRATTON
HARRY CUSTER
SLADE
William Hadfield
Rose Montgomery
Richard La Reno
Edward Elkos
Richard Turner
Lita O'Farrell
Ronnie
Max Goldberg
Col. Houston
Pattie Houston
Chas. Haeffle
Mabel Trunneile
Edward Garle
Mellicie Grant
Robert Lowry
Miss Cécile Guyon
Miss Jane Renouardt
Mrs. Marie Laure
Mr. Wague
Mr. Treville
Miss Ulrich
Louis Fitz Roy
A. H. Hayn
DOTTY WOLBERT
Silver Baker
Garry Beecher
Diana Terrace
Kewpie Moran
Edward Hearne
John Fox Jr.
Kal McCloud
W. Fogers
Rev. Jas. Thorpe
Suella Marine
Mayme Conroy
Jeanette Gregory
David Bruce
Simon Gregory
Maggie
Susanne
Dorgan
Cissie Fitzgerald
George Allen
Jos Bright
David Baird
Evelyn Selby
Richard Foster
Godfrey Livingston
Helen Galvin
v. Arnold Lucy
LEILA HYAMS
ALPHONSE ETHIER
LORRAINE FROST
WILLIAM COURTENAY
CHARLES WELLS
Edwin B.Tilton
Ed. Sedawick
George Barnes
Harry Cornells
Larry Donovan
Marjorie Taylor
Dusky Walters
Zeb Taylor
William Straus
Sam Sidman
Ayrel Darma
Virginia Bradford
Frank Marion
Milton Holmes
James Aldine
Budd Fine
Merta Stirling
Edward Davis
Dorothy Dahm
Wade Hildreth
Bob Custor
Pat Boggs
Howard Fay
Skeeter Bill Robbins
WM. H. TURNER
FLORENCE LAWRENCE
REED HOUSE
MARC MAC DERMOTT
CLARENCE BURTON
WALTER STEVENS
ADA GLEASON
Ray Tuckerman
Jack Boone
EDDIE Phillips
Eunice Vin Moore
Fred Truesdale
Clara La Moyne
John Stanhope
Paul Guide
Albert Signer
Marie Jalabert
Kirke
Joseph Kilgou
MISS GAIL KANE
W.W. Crinans
Walter Dowling
Walter Havers
Dorothy Leary
Kansas Meehring
Wm. Engle
Geo. Welch
Merwin Edwards
Bessie
Winfield, Actor
Helen Mitchell
Harry Holcomb
Jimmie Fielding
Allen J. Holubar
Fritzzi Ridgway
Fornzie Gumm
Lou Morrison
Hugh Miller
Andres de Segurola
Ivan Lebedeff
Maurice "Lefty" Flynn
Jean Perry
Hazel Rogers
Rey Ripley
Robert Gautier
William L. Edsforth
Bliss Hillford
Yale Bennet
Paul Harrington
Herbert Arden
Chris Rube
GEORGE JESSEL
Stanley Sanford
Henery Mortimer
Paul Cazeneuve
Tom Cameron
S. Barrett
Mr. Chevalier
Joan Hoff
Lorraine Estes
Jed Hawkins
COUNTESS DU CELLO
Frank Casey
W. J. Driesbusch
Pete Loose
Joseph Ransome
Fanny Cohen
E. Allyn Warren
Billy Aber
Jean Johnson
Irene Trentoni
Laura Frankenfield
Eugene Ormonde
Ed. Duane
Frank Wade
William H. Jimpson
Billy Musgrove
Liane Carrera
Robbie Vernon
John Stone
Tom Loring
Pop Graves
Robert pudley
John Drake
Sidney Drake
W. H. Tooker
Catherine Colhoun
Miss Clement
Miss Coney
JACK BENNETT, JR.
MISS EDWARDS
VAL PAUL
DOC CRANE
LINA CAVALIERI
LUCIEN MURATORE
Louis Grisel
Jack Davidson
Kate Biancke
L. Wolheim
Henry Ainslet
Flora Le Bretton
Ralph W. Chambers
Alec Greenwood
Harry Gripe
Zeffie Tilbury
Albert Tavernier
Harpo Marx
Rory Calhoun
Michael Chow
Yoko Tani
Pierre Cressoy
Robert Hundar
Camillo Pilotto
DAVE BRYCE
Bonita Romero
Julian Romero
Francisco Sanchez
William Kern
Dorothy Kern
GEORGE BERANGER
ALBERT MCQUARRIE
H. Reeves-Smith
George W. Howard
N. A. TZERNOWA
A. E. URGIMOW
W. A. DEMART
David (Cricket) Kelly
H. M. Thurston
Mr. Higgins
Mr. Kelly
Chas. Haefeli
Edggr Jones
Steve Farrel
PANSY PORTER
Nerma Nichols
R.O. Pennell
Grace Aide
H.L. Swisher
Harry Moody
Phil Ainsworth
Roger Chapman
Tom Sullivan
Josa Melville
R.D. MacLean
Paul Gordon
Edwin Holt
William Walworth
Arthur Halman
Soul Harrison
Rolland Reed
Armand Priscoe
Herbert Abbo
Francis Newburg
Mrs. Clifton
Frances Hall
Louie Cheung
Jack Hobbs
Malcolm Cherry
AL WDLSON
Louise Pullins
Ella Vance
Albert Jenkins
Tom Butts
Hildred Reardon
Charles Mussette
Harold Thomas
Lillian Griffis
Charles E. Feehan
Jim Ormsby
Charles Dillon
Lucille Reynolds
Dave Bland
Pebble Grant
なし
Lorenzo Carilo
Duane Thurston
Estelle Clark
Dorothy Gerard
Monty Brace
Mr. and Mrs. Sidney Drew
Russel Simpson
Al Cooko
John Aason
Eric St. Clair
Eddie Pole
Bill Wescott
Harry Schumx
Anna Harding
Dick Harding
Glynn Savoy
William Ingersoll
Emmett Corrigan
Grace Milton
William Demoss
Betty Jane Snowden
Marjorie Morton
Chris Cotterill
Benjamin Burley
Richard Ollwell
Maggie Driver
Sergt. Powers
Ellen
Winifred Ollwell
Jas. Liddy
BILL CODY
BOB HOMAN
NOLA LUXFORD
TOTE DUCROW
DOT PONEDEL
EDWARD BOULDEN, HARRY BEAUMONT, WALTER HIRE S
Alice Charnock
MITCHELL LEWIS
Harry Lamdale
CATHERINE VAN BUREN
JG Bryson
EDDIE HEARN
JOSEPH SWICKARD
SIDNEY DREW
DORIS FENTON
Linda Farley
Emily Lorraine
Robert Duane
Colleen O'Brien
Pa O'Brien
Ma O'Brien
Ted Hanson
James W. Morrison
Mario Marjaroni
Gordon Hamilton
George S. Stevens
Antoinette Walker
Beryl Mercer
W. C. Carleton
Mr. Barney Gilmore
Mr. Roy Gahris
Miss Grace Norman
Miss Lillian Niederaur
E. F. Roseman
Mr. John Sharkey
Miss Violet Stuart
Mr. George Stone
Miss Mabel Wright
Mr. Roy Applegate
Mr. Richard Lysle
Rex de Rosseli
WILLIAM POWELL
FLORENCE AUER
TONY GILLARDI
Edwin Cobb
Mary Hay
Francis Conlon
J. Warren Kerrigo
Dr. Blytell
Junior Goghlan
MAUD GEORGE
Gora Williams
Shirley Davis
Rupert Chadwick
Marvin Dexter
Vic. Goss
Edw. Clark
Jackie McHugh
Birdie Fogle
Laura Rittenhaus
Ralph E. Bushman
Christopher Brent
Molly Preston
Alexandre Herbert
Rieca Allen
George Paton Gibbs
A. Lloyd Lack
Stanley J. Preston
Edw. Jobson
Dathleen Kirbham
Wm. Marshall
Chas Edler
Louise Sothern
GENE DEL VAL
DeSACIA MOORES
DOROTHY HALL
Betty Petterson
A.V. Bramble
E.Compton Coutts
M. Gray Murray
Doralldina
VICTORIA FORDE
HOWARD FARRELL
NIGEL DU BRULLIER
Jim Bradley
Ruth Bradley
Mustang Pete
Bill Daily
Tom Lacy
Marcovitch Einstein
Reggie Einstein (as-bey)
Lew Mendel
Esther (as a girl)
Miss Peggy Richard
Fred Douglas
Baby Weiser
Hazel Turney
J. Raymond Barrett
Madame Petrova
Fritz De Lint
Bert Tuey
Grace Florence
Cora Milholland
Gypsy O'Brine
Dorothy Kelly
Violet Blythe
Harry Rattenberg
Otto Robe
Robert Darrell
Margarete Schoen
Hanna Ralph
Hans Schletto
Charles Ryckman
Bert Roche
Phyllis Ladd
Mrs. Fensham
Cyril Adair
John Ladd
Violet Lind
Jerry Hatton
Wm. A. Strauss
Katherine Spencer
Dorothy Richards
John O'Connor
Bill Hartigan
Doris Walton
Bob Logan
Sam Walton
Pete Morton
Billy Harper
Carlton Griffin
Will R. Sheerer
PETE GERALD
FRANCIS FORD
LEWIS BURGERT
VANDA WILLEY
Grace Hamilton
C.L.
J. Lowell Quackenboss
Cunningham
George Berrill
E.Rosebrough
Ethel Fleming
George Henry
SWEENEY
LEE MCGUIRE
NORTH
Lew Brice
Robert T. Haines
ROSA MORELAND
George Sala
Detective Flint
Dugall
Reverend Stiles
Huguette Duflos
Henri Houry
Marcya Capri
Georges Vaultier
Jaque Catelain
Lee Grey
Jack Dilton
Louise de Rigney
Lotta Burnell
Harry Davenport
Harry Anstruther
John Stanton
Wilfred Young
MORRIS CYTRON
EDWIN J. BRADY
Kate Wilson
Henry Whitmore
Florence Walcott
BeSSie Eyton
Steve Rock
Orrin C. Johnson
Clairette Claire
Jack Giddings
Mrs. Hernanded
Alfred Loring
Eileen Evans
Mary Martin Williams
Frank Carrington
Brownie
Princess Nona Darkfeather
Junior Coughlan
Ivan Petrovich
Firmin Gemier
Gladys Hamer
JULIUS STEGER
Chas. F. Gotthold
Louis Calhearn
Jerry Peterson
RON STEWART
Jack Lodge
McQuire
Adolphe J. Menjou
Alderman Shea
Aileen Shea
P. Wadlington Burke
Ernestine Jones
Nora Dempsey
Patricia Stanhope
Scott Warner
Aunt Virginia
Aunt Penelope
Billy Carmichael
Tom Morton
Professor Bonnard
John, the Barber
Count Coc-Coo
William Goettinger
Robert Wharton
Harwood
Jerome Hartley
Leonora von Ottinger
Wilmer Walter
LOUISE LOVEL
Even Wade
H. C. Carpenter
Marion Fernley
John Black
Robert Merritt
Bill Garvin
David Higgins
Alice Taffe
Helen Darling
Jane Wilson
Curtiss Jennings
George Majeroni
Helen Green
Otis Vale
W. E. Dyer
Ethylyn Chrisman
Mary Parkyn
U.K. Haupt
Joe De La Cruze
Edna Granville
Robert
Herbert Conroy
Nita Cavaleri
Tom Bay
Marianna Moya
Echlin Gayer
Baroness de Hedemann
Jane Auburn
Bert Wales
Gen. Lodijensky
William Moran
Wm. Conklin
William Wainwright
Marry Bates
Armand Prisse
Richard Duvall
Alma Belwin
Wm. Carwood
Wardena Caulfield
Ethel Burton
Herold T. Hevener
Barbara Castleleton
Bobbie Connelly
Hazel Coates
Jack Nellson
Jane Madisor
Osgood Perkins
Elise Cavanna
Ed Garvey
George Fisher
Blake Wendell
Ashton Blair
Florence Grant
Grace Danby
Allen Danby
Louis Barrentos
Allen Brander
Bailey Dryden
Tommy Taber
Dora Wainwright
LOWELL SHERMAN
Francis J.MacDonald
Richard Botsford
Richard Barry
Harry Lawton
PETE FIELDING
WILLIAMS
LARK ASHBY
ARABIN
HILDRETH
DETECTIVE TYRON
LADY GWENDOLYN
JACQUES
Shella Adams
Thos. R. Mills
Catherine Wallace
Relyea Anderson
Don Baily
Amy Wood
Wm. Braddon
Dick Braddon
Sylvia Smith
Mayn Kelso
KATHLEEN MYERS
NAT CARR
STANLEY TAYLOR
CARROLL NYE
AGGIE HERRING
Charles Dorey
"Lassie" Bronte
Belburn Moranti
Jeanne La Roche
Miss Lyndall Olmstead
Sidney Mather
Lionel Chalmers
Allen Conner
H.P.Woodley
Chas.Esdale
Miss LAURA LYMAN
Mr. JOHN F. CARLETON
Mr. E. P. SULLIVAN
Mr. ARTHUR MORRISON
Mr. MICHAEL HANNAFY
Mr. W. H. CAVANAUGH
Mr. R. J. LEARY
Miss MARGUERITE MARQUIS
Miss GLAD GILLIAN, Miss FRANCES PURCELL, Miss RHEA RAFUSE
Rosie Cooper
Freddie Smith
Tony Rossi
Jefferson Southwick
Mr. Haverty
D. C. Hendricks
MARY ALDEN
PRISCILLA BONNER
Joel Butterworth
Vicky Johnson
Leo Binnis
Andy Johnson
R. Senior
Fred Hadley
Harry Lane
Edna Wheaton
Yvonne Routon
Sibyl Carmen
Frank McCormick
Mrs. Gallagher
WILLIAM NIGH
Robert Eliot
Victor De Linsky
Cecilia Griffith
Florence Vincent
Mrs. William Nigh
Lydia Yeomans Titus
Zenda
Elizabeth Eldridge
Jacques Martin
William Jefferson
Bruce Macomber
Buck Moulton
MAE FIGMAN
LOLITA ROBERTSON
Justin Ramos
Joe Bonomo
Jane Warrington
Jean de Briac
Irving
Maine Garey
Carleton Griffin
Fritzzi Brunnette
Wm. Sheerer
Minna Ferry Redman
Abby Hopkins
John Mackay
J. B. Hanks
J. Booth Huntington
Little Zoe Rae
Lena Baskett
B. O'Farrell
Lewis Morrison
ESTELLE BRADLEY
Sable Johnson
Capt. Charles
Jefferson Todd
Barbara Brereton
Louis Castiga
Joe Alabam
Col. Brereton
C. E. Anderson
M. Biddulph
Julia Crawford
Veronica Lee
Joseph Lee
Bob Burton
Daisy Adams
Thomas Burton
Tamara Loraine
Princess Ardacheff
Stephen Strong
Olga Gleboff
Count Valomne
Tatiane Shebanoff
Sasha Basmanoff
Princes Murieska
Boris Varishkine
Sonia Zaieskine
Capt. Wilfred Gough
Michael Mitchell
Nattie Comont
E. Eliazaroff
MURIEL OSTRICHE
Emil Chautard
Eva Heaslett
Mary Hempden
Leroy Mason
Isabel Dintry
Gus Balfour
Max Fisher
William Ellingford
Roy Stecker
Helen Davidge
David "Red" Kirby
W. A. Carroll
Muriel Gray
Gladys Keck
Chas. Canfield
Willie Hopkins
CLORINDA GILDERSLEEVE
William B. Davids
Sig. Falconi
John Prim
Reginald Paynter
Eric Dalton
Nettie Penning
Arthur Stockbridge
Eddie Sturgess
Geo. E. Murphy
Nick Long, Jr.
Dick Collins
Hector V.Samo
L. W. STEERS
HEDDA NOVA
SYN DE CONA
Dad Learned
MUNROE SALISBURY
HOWARD DAVIES
LILA LESLIE
MARTIN BEST
DWIGHT CRITTENDON
HARRY BOOKER
BERT KINDLEY
Allan Frisbee
Vivian Collins
Tom Bradshaw
Slinky Davis
Gloria Thomas
TOM
ARMAND KALIZ
IVY LIVINGSTON
W.A.CARROLL
Herbert Bethew
Roy Justi
Betty Marvyn
Richard Waite
Samuel Waite
Marga Rubia-Levey
Thomas Lewes
Julius Manning
Tony Keppel
Viola Waite
BEN LYON
AILEEN PRINGLE
Lucian Prival
Gwylm Evans
M^ry Dibley
Lili^n Hall-Davis
Myrtle peters
Jerrald Robertshaw
Robert L^ng
Ernst Pasque
Wallace Worsley
Julia Hay
Billy Bibbs
Charlotte Lillard
Bart Lindley
George Stanley
Vernon Sniveley
ROBERT WARWICK
GERDA HOLMES
MOLLIE KING
L.C. Shulman
George Fouth
Dorothy Barnett
Rufus Renshaw
Helen Renshaw
Jim Burton
Helen Summers
Hyam
Ethel Mantell
Marie Booth
Emma Kemble
John B. Hollis
Venie Atherton
Violet Hall Caine
William H. Burton
James Moreland
Gaston d'Henricourt
Mr. Aage Hertel
Thomas Wilson
Helen Brown
Jack de Puyster
Bert Van
Mrs. L. Livingstone
Grace Livingstone
Wilmot Williams
Pearl WHITE
Robert Gainsworthy
Jack Sanders
Fred Gambol
Bertram Hadley
Willard Mack
Robert Wagner
Mag
Helen Linroth
Tom Santochi
Billie Jean Phelps
Wilbur Mack
Cartwright DeHaven
Margaret Townsend
Chas. Dudley
Edw. Brown
Frank Coffray
EVART OVERTON
BILLY BLETCHER
LILLIAN BURNS
patty Alexander
Margaret Wycherly
John E. Kellerd
Lawrance D'Orsay
Eddie Dunn
Marge Evans
Mrs. Allen Walker
Eddie Scanlon
Harry Emerson
Lewis Vickers
J. Herbert
Edward Boulder
Lucille Lawton
E. C. Wallack
Gypsy Sontoris
DANNY CANAVAN
DENNIS CANAVAN
BEATRICE NEWNES
Rodman Cadbury
Billy Sherwood
Miss Coventry
Virginia Fox
Tiny Ward
Lot Farley
Paul Porter
E4 Tilton
Jackie Ott
William Burton
Douglas Carter
Elizabeth Witt
Eleaner Blanchard
Francis Jcyner
JESSE GOLDBURG
Michael Vasaroff
Jean Galeron
Seymour Rose
Alice Nowland
Mother Anderson
Harry Jenkinson
John Keith
Billy Mayberry
Joseph Barrès
Adelside Bronti
Master Jack Huff
Paul Perez
Jerry Foster
Muriel Dana
John Herdman
Clita Gale
Roy Darsey
Henry Stanford
William Warsworth
Alma Jordan
Harry Springler
Betty Allen
Amelie Thorndike
Wedgewood Noell
Myrtle Steuman
Dorothy Moore
Mrs. Ethel Clark
J. Kenneth Simpson
Thomas
Miss Cal
Freddy De Peyster
Vera Van Zandt
Black Morgan
Alice Norris
RICARDO FITZMAURICE
WANDA HELD
Mlle. THAMAR FEDORESKA
ROSITA MARSTINI
C.C.Holland
GEO. BICKEL
Alfred Kepler
Armand Kalise
Helen Tracey
R. La Roque
Tiny" Ward
Laura Hicks
Jim Bailey
Bob Ross
Joshua Hicks
Dan Hicks
Dolly Brady
Chas. Brady
Maggie Muldoon
Danny O'Rourke
Miriam Welton
Joe Browning
So-Jim
Gregory Kelly
George Seigmann
Oscar Figman
Edna Mae Oliver
Marshall Stedman
T. H. Gibson-Gowland
Edward Cox
Madge Philbrick
J.A. Morley
Nonie Kayliss
Bruce Henderson
Jack Welch
Miss Bonnie
Buddy McQuoid
Albert Busby
MARCELLUS STARR
Josephine Pollock
Barrett Prentice
Alice
Bobby Connelly
Helen Connelly
Ann Wallick
Joseph Cooper
Maurice Levigne
Alfred Goldberg
Edward. Stanton
Louis Stearns
Maurice Peckre
Ruth Sabin
Frank Mitchell
Holbrook Blynn
Rodney Martin
Bob Gray
L. Hahn
BABY NORMA
Mr. Sheldon
“Heinie” Conklin
Mr. Gomp
Edward Mackay
Gertrude Keller
Cynthia Williams
MARGARET SHELBY
EDWARD JOBSON
Demetrius Mitasoras and John Cough
Gloria Handwork
William Stonell
J.Harrison Gray
Betty Kennedy
Dolly Carleton
Hortense Brown
Jack Kennedy
Reese Gardiner
W. C. Canfield
E. A. Clarke
Louis Short
Vic Goss
TOM MARTIN
ROSE SHAW
JOE HARRIES
REV. THOMAS PARKINS
Evelyn Walsh Hall
Ray Fox
Rev. Robert Fenton
Oscar Morse
Frances Burgess
Phil Dunham, Elfe Fay, Glen Cavender, Blanche Payson and Jack Lloyd
EARL MONTGOMERY
“Babe” London
Edward Nolan
Dixie Lamont
Larry Richardson
Stephen Stanton
Ralph McCollough
Jim Dexter
June Clay
Gladys Johnson
Sydney Ullman
Carl Ullman
Verne Winters
Minnie Prince
Jessie de Jaintette
William Friend
GEORGE SOULE SPENCER
JUNE DAYE
W. W. BLACK
WALTER P. LEWIS
ROY SHELDON
ROY GAHRIS
George Randall
Inez Harper
Gladys Stone
Red Hicks
Alice Sanderson
PAULINE SAIN
Rosa Raisa
Giacomo Rimini
BECKY BUTLER
ALBERTA LEE
JEFFERSON SUMMERS
SYN DE CONDE
HELEN SULLIVAN
Andrew Horton, Jr.
Sydney D. Grey
EDDIE LAMBERT
Lenore Von Ottinger
Orma Hawley
Violet Kane
Texas Kid
Abdul, the Turk
Charles Feehan
Walter E. Perkins
Viole Rana
Harry Clyde
Belly Cruse
Harry Desmond
Matt Harned
W. L. Gibson
Eleanor Miller
Lillian Vail
William R. Biddle
John Sturge
Howard Crompton
Claire Dubrey
Donato Vampa
John Agnew
Dello Agnew
Jim Wang
Maybelle Spaulding
Sam Ash
CHARLES BROWN
HUGHIE MACK
ANNA LAUGHLIN
NICHOLAS DUNAEW
JOHN T. KELLY
ETHEL LLOYD
O.H. Martinek
James Dale
Margaret Adamson
Ivy Montfort
Lloyd Holton
Mr. Holman Clark
Mr. Lawrence Grossmith
Mr. Alfred Bishop
Miss Vane Featherston
Miss Doris Lytton
Mr. Rudge Harding
Mr. Tom Mowbray
Miss Mary Brough
Mr. J. H. Brewer
Miss Molly Farrell
Mr. J. R. Tozer
Mr. Patrick Quill
Miss Isobel Ohmead
Miss Joan Morgan
Karr
Jos. Knight
Baby Helen Armstrong
HARRY DEVIES
FRED HUNTLEY
HARRY HILLIARD
NEIL HARDIN
Nora Hayden
Lizette
Aida Arboz
Walter Sondes
Nora Swinbourne
Lilian Hall-Davis
Francis Lister
June Talbot
Albert Ellis
William Ephe
Josephine Rice
McBan
Jack Ryan
Rea Martin
Irma Dawkins
Betsy Ann Hisle
Carmencita Johnson
Gordon Thorpe
Constance Berry
Edith Stockton
Ben Probst
Mr. Wogritsch
Mr. Nelfert.
EILLE NORMWOOD
J. R. TOZER
MME. D'ESTERRE
BUDDY ROOSEVELT
Violet LaPlante
Lew Meehan
N.E. (Shorty) Hendrix
Lillian Gale
Terry Myles
Dick Bodkins
Francis Nelson
LEONIE FLUGRATH
Mary S. Smith
Thurston Hill
Bartley McTullum
Oliver J. Eckhardt
William Sorelle
Yvonne Chevalier
Dana Todd
Tony
Charles Brooke
Sally O'Malley
Sylvester Soapsud
Sofia Soapsud
Pop Jones
Chester Kyckman
Jack Dayton
Elsie Thornton
Mr. Frederick Christensen
Mr. William Bower
Miss Edith Psillander
Mr. Henry Seemann
Miss Alfi Zangenberg
Nora McShane
Terry McShane
GASTON CLASS
JOHN H.Gardener
Greta Vonrue
Paul Weigl
Wanda Curtis
Mathew Flagg
Jane Gaylord
Roxbury Brewster
Miss Van Ottenger
Audrey Kirby
Tom MacEvoy
Wm. Sloane
RICHARD BARTHELME
CAROL DEMPT
FLORENCE ST
CRAUFORD KEN
ADOLPHE LESTINA
WILLIAM JAMES
JACK MANNING
Veter Pegg
BARTINE BURKETT
VICTOR POTEL
NELSON MCDOWELL
EDWARD WALLOCK
ALBERT BREIG
HARRY LORAIN
TINA MODOTTI
SYDNEY DALBROOK
WILLIAM BROWN
C. G. Brides
AUDREY FERRIS
Alice Drummond
William Farney
J. FARRELL MACDONALD
Norma Huntley
Emanuel Gadd
The Brothers Toop
Jill Bolt
The Widow Bolt
Harold Van Cleve
Ted Adams
Peggy Davis
Sylvester Tomkins
Tim Mooney
Madge Morrison
Jack Sanderson
Hott Gibson
Billy Fletcher
Leah Bard
Rita Sachetto
Alice Elliott
Fred Hartley
Olive Trevor
Mrs. Garrison
Lesly Casey
Danny Sullivan
Laura Newman
Maud Cooling
John Wessel
Ed Lynch
Koling Kelly
Dorothy Bebb
Betty Compton
Herbert Grey
PEGGY PEARCE
CICELY OSBORNE
CLAIRE WINSTON
PHILLIP ASHTON
SYEMOUR ZEILLOFF
Mlle. Madeline Farisel
M. Mancini, of the Porte-Saint-Martin
M. Teddy, of the Alhambra, London
Mignonne Golden
Cynthia
MR. T. H. MACDONALD
MR. J. HASTINGS BATSON
MISS DOREEN O’CONNOR
MISS JOAN SCADDAN
JAMES VAN DYKE MOORE
Mollie Anderson
Robert Forrest
Henry Chadwick
Haig
Harry B. Norman
Adrienne Hayes
Miss Mabel Bert
Miss Gladys Leslie
GEORGE PARSONS
HENRY SEDLEY
VAN DYKE BROOKE
MISS PEGGY PARR
Frances Wood
De Wess Seewir
Ezra Snuck
Magie Breyer and Mrs. L. Ford
Jack McGowan
Dainty Lee
ANNA LUTHER
FRANK ALEXANDER
HARDY GIBSON
HARRY O'CONNOR
DORIS BAKER
BILL HAUBER
Kate Roberts
Ned Johnson
William Grinley
Janet Darley
John Hamel
Jessie Flugrath
Harrold Newman
Doris Field
Gyp Carter
Amy Gray
Larry Gray
Bob Ellis
Betty Marlowe
John Marlowe
Dan Ferris
Randa Hawley
Alyce Mill
Frank Campea
Alma Bennet
Capt. Robert Rope
Tommy Rya
Charles McHug
G. Howe Blac
JUNE MULLINS
Jack Busby
Shirley Bryson
Caroline Harris
Walter Worden
Fredie Drugman
Baby Blackburn
JOSEPH DISKAY
Clara Kimball
Pa!
Doris
Mrs.
E.V.
Carl Martz
Harry Grippe
Lillian Elliott
Anna Gilbert
BILLY McVEIGH
SCOTTIE DEANE
ISOBEL DEANE
Bill Duncan
Rolph McPherson
Seth Daggart
Joe Gault
Red Flynn
Rose
ROBERT FRASER
GLADYS BROCKWELL
IRENE HUNT
HOWARD TRUESDELL
JACK HENDERSON
ROSCOE KARNS
OLIVER CROSS
ED BORMAN
“SPEC” O'DONNELL
Dick Snell
Alida Hayman
WALLACE EDDINGER
CAROL HOLLAWAY
FREDERICK MONTAGUE
FREDERICK VR0OM
FRANCIS TYLER
MR. MACHIN
ROBERT DUNBAR
Percy Prin...
Ruth Rand
Kotah
Fred Brandon
Eva Heazlet
GEORGE GEBHART
ED. CLARK
MYRTLE REEVES
ELMER McINTURFF
M. Damores
Mme. Lemercier
Charles Gardner
Jacques Hermann
Juliet Musidora
William Nash
Elsa Bambrick
Mr. Horne
Fanny Rice
Adelaide Hedlar
Dick Vain
Gibson Goland
Latayette McKee
Nelvin Mayo
Dot Dufee
Estelle Evans
Yvonne Pavis
BROWNIE" VERNON
HENRY SCHUMEN-HEINK
THEO CLEGHORN
Hank Man
BETSY SPRATT
HEINRICH VON WINKLE
Pat Somerset
Helen E. Sullivan
Hart Gamble
Steve Austin
Emily Dean
Mr. Dean
Red Larson
Jno. Judd
Jack Livingstone
Kate Anderson
George Cummings
Joy Whitcup
RALPH EVERLY
GEORGIA DANIELS
Harry Daniels
A. G. Corbel
Ben Callahan
Bill
E. Brown
Asuti Hishuri
Ito
Arthur Bouchier
Miss May Palfrey
Miss Marjorie Hume
Bertram Burleigh
Mrs. Hayden Coffin
Miss Meggie Albanesi
Mrs. L. Thomas
L. C. Carelli
Gladys Cuneo
J. Clark
William D. Chalfin
Pasqualina Devoe
Lillian Brown
I. De Castro
Bodil Rising
Lorothy Seastrom
Hans Joby
M. Krauss
John E. Brennan
Dot Gould
Ethel Dury
Dinky Dean
Mai Wells
"Chuck" Riesner
Dorothy Marion Mack
Jim Austin
Lester Calvin
“Mother” Benson
Addie Frank
WILLIAM FRANEY
LILLIAN PEACOCK
MILBURN MORANTE
Anita Thorton
Alex. K. Shannon
Zelda Crosby
Mrs. R. S. Anderson
Ivy Ward
ADA BOSHELL
EDWARD FIELDING
EDGAR NORTON
CARL SAUERMAN
VERA FULLER MELLISH
MERCELTA ESMOND
ANTON ASCHER
VICTOR LE ROY
ROBERT ENTEISTLE
Mae Howard
A. W. Bates
SAUNDERS JULIAN
Betty Bonnyface
Dick Sterrett
Robert Emmons
Betty Thomas
Suzanne Fleming
Arno
George Sherwood
Frances Teague
Frank Morris
Stuart Sage
Philip Tead
Allyn King
ANNA MAYHEW
LEONARD SHUMWAY
Mary Creighton
Benjamin Horning
Adol
Charles W. Ritchie
RALPH GRAVES
CLARISSA SELWNN
J. EDWIN BROWN
Edward De Wolff
Flora Lee
ROSE E. TAPLEY
LIONEL ADAMS
REGGIE SHEFFIELD
CHARLES WELLESLEY
MANDY WILSON
Lucy Doraine
William Farleigh
Harry de Loon
Jimmy Fox
John Foster
Spike Gans
Simon Dudsbury
Dickson Fay
Dr. Adams
Elsie Wheaton
Joseph Ransom
Frances Bayles
Milburn Noranti
Larry Maddox
Dorothy Hunter
Ross Hunter
Reginald Brooks
Jim Ashland
Hoke Charming
Roy Bassett
Bob Willis
Doris Westley
Phil Valentine
Francis Hargreve
Horace Grant
Arline Mayfair
Jimmy Winthrop
David Mayfair
Teddy Filbert
Bobby Kingsley
Glydas Jerome
William Sweeney
Dan Moyles
Chas. Judels
Marie Collins
MARY LEE WISE
SAM BUCK
MR. GALVEZ
Fritz de Lint
Chas. Dungan
John Dudley
Marilyn Reid
Elenore Sutter
Jean Thomas
DAVE BUTLER
KATHERINE KIRKHAM
EMMET KING
Chas. Hutchinson
Chas. Bryant
Richard S. Barthelmess
Nila Mac
Alexander K. Shannon
Theodora Warfield
Chas. Chailles
Mdle. Lyda Borelli
Mdle. Cecile Tryan
Thomas Benton
Ida Benton
FREDERICK HILTON
ELEANOR BOARDMAN
MATHEW BETZ
Floyd Johnson
Violet Mersereay
Daisy Erling
Bobbie Erling
William Erling
Violet Craig
Ina Berke
Marguerite Linden
Vm. Bertram
Vm. Tedmarsh
RICHARD STANHOPE
TOM DALY
ETHEL STEPHENS
Thomas MacNey
WILLIAM BLETCHER
HARRY A. FISHER
FLORA FINCH
JAY DWIGGINS
Tom Lovejoy
FAY THOMPSON
WALLACE RICHARDS
COL. MORRISON
JAMIE THOMPSON
MRS. THOMPSON
FRANK COAKLEY
Ruth Barrett
Jack Brown
Priscilla Glenn
Dick Travers
Mr. Powers
Joan Moss
Phoebe Starling
Sam Starling
Duchess Stella di Lanti
Fred Becker
Johnnie Gains
Mary Gains
Thomas Gains
Jim Fuller
John J. Burrows
Zelda Burrows
Otto Schultz
Gretchen Schultz
Silas Gains
Little Johnnie
Little Silas
Charles Ritchie
Dick Armstrong
PHYLLIS LORD
Bessie Allen
Dixie Marshall
Emile Agoust
BILLY ARMSTRONG
Helen Martin
J. Byrnes
George MacIntyre
Claire Hillier
Kitty Reichert
William Morse
Bud Watkins
Sydney Jordan
William A. Steele
Bowditch Turner
Martini
A. Marcus
Joseph Swilard
Bertrem Grassy
Adelbert Knott
Milano
Venezuela
Eberts
Kennedy
HENRY KOLKER
Elsie Balfour
Orlando Daly
Katheryn Lean
Mary Eaton
Lawrance D’Orsay
Horris Millington
MARCIA SAVILLE
John Saville
Martin Kent
Simon Downs
Robert Convilie
Mildred Wayne
DICK LIVINGSTON
HOLLY LIVINGSTON
Paul Latham
Nancy Latham
John Bayly
Reeves Sason
ANTRIM SHORT
FREDERICK STARR
THOMAS DOYLE
FRANK AUSTIN
COL. KINKAID
STAPLES
OLD MORGAN
MARY DOYLE
KITTY DOYLE
Mrs. Robinson
TOM MINGLE
SALLY MADISON
RED WING
Jack Huff
Josn Carew
Reuben Meade
J.J. Corbett
CHAS. DORETY
STANLEY DARK
THOMAS R. MILLS
GARRY McGARRY
CHAS. ELDREDGE
Yuki Onda
Pierre Le Beau
Prince Hagane
Senator Todd
Mrs. Todd
Gwendolyn
M. Seki
Maud Varian
TOM MORRISON
WARDA HOWARD
Juan de la Cruz
Helen Chadwick
MISS VIOLA ALLEN
MR. RICHARD C. TRAVERS
MR. John Thorn
Miss Florence Oberle
Mr. Ernest Maupain
Miss Camille D'Arcy
Miss Emilie Melville
MR. Sydney Ainsworth
MR. John Cossar
Mr. Thos. Commerford
MR. Frank Dayton
Mr. Frederick Wood
Miss Julia Stumat
Alec. B. Francis
Grace Moreland
Mary Sennison
Gladys Briggs
J. Gnnnis Davis
Miss Mildred Bright
Will E. Sheeror
Chas. Morgan
Miss Alice Knowland
Miss Evelyn Fowler
Miss Helen Martin
Miss Isabel Gonzales
Mr. GuyHeadland
Mr. J. W. Johnston
Mr. Fred Truesdell
Mr. Lou Wood
Miss Mildred Tierman
Miss Helen Drèw
Miss Clara Horton
Willie Cottrel
"Spike" Robinson
JIMMY BURKE
Jack De Lacey
Big Joe Roberts
Mary Coughlin
Natalie de Lontan
Ricardo Espino
Deon Routh
JANE GAIL
LOIS ALEXANDER
DAN HAMMON
EDNA PENDLETON
WALLACE CLARK
MARTIN MURPHY
LEVITICUS JONES
WILLIAM WELCH
Adelle Lane
Flora Somers
Philip Somers
Moolie McConnell
George McDaniel
Golda Madden
Patricia Hannan
Robert Connass
Edvard Karb
Benjamin Turbett
Tibi Lubin
Francis Everth
Francis Herter
Alfred Schreiber
Wilhelm Schmidt
Ditta Ninjan
Lilly Lubin
A. D. Weise
Maxwell Sargeant
Hilton Allen
Fred Vroom
Elsie Dean
William Gavin
Martin Ross
Sima
Robert Frazier
Jack Ho
Mardu Farrell
Emma Thomsen
Charles Zimmerman
Hugh Gallard
Daniel Druce
Edna Gallard
Sylvia
Bennie Suslow
Barbara Benton
William P. Carleton, Jr.
Barbara La Mar
ANN PATERSON
Andres Blake
Barry Macklin
Lou King
Charles Edmay
Sylvia Smalley
Leroux
Alice Mason
Aime Simon-Girard
Pierrette Madd
Monsieur De Max
Claude Merelle
Monsieur Marintellli
P. De Guingand
Jeanne Desclos
Will S. Stevens
Roy Clair
Kathleen Allaire
Ruth Thorp
Edith Evans
Loring Page
Rita Norton
Roy Ferris
John Evans
Henri Menjou
Jimmy Burns
Nellie Anderson
Jim Claverling
Lawrence Grant, Andre de Beranger, Dot Farley, Barbara Pierce, Brandon Hurst, William Courtright
THOMAS VAN DYKE
Billie Gettinger
Peggy and Violet Shramm
Jim Carter
Manlong Hamilton
Thena Jasper
Clarence Ford
Mr. Morris
T. Du Crow
Yorke Norroy
Carson Huntley
H. C. Carvill
Fred A. Stanton
Charles Edwards
May Allen
Carl De Mel
John Mc Cabe
Frank Harkness
Jane Mc Eachern
W. W. Cohill
William Busby
Count De Planter
Grace Marceat
Frances Cornell
Capt. Van Bausen and Herbert E. Jelley
Hermann Gerold
William Gaffney
May Hall
Ernest Marion
Kate C. Tonoray
Carrol Johnson
Grace Martin
ALLEN PERRY
PHILLIP GRANT
MARIAN TURNER
MR. TURNER
TOM WELDON
SEN YAT
IRENE ALDWIN
MR. KUWA
Peter V. Wilkinson
Leslie Wilkinson
Giles Illingsworth
Eliot Beekman
District Attorney Leech
VEDA McEVERS
JOSEPHINE RICE
Lincoln Caswell
MALCOLM SEBASTIAN
Mrs. J. H. Brundacg
Caroline Wright
Frenchie Bianchi
Capt. Peacocke
Marjorie Illison
Kate Blanke
Esther Banks
NILES WELCH
COIT ALBERTSON
HELEN SHIPMAN
NELLIE SAVAGE
Mora Kingsley
Ethel Kay
Bart Nask
F. Abbott
Rosa Gcre
May Beth Carr
Hilda Twogood
Thomas Hedden
Marjorie Killison
Bruce Bytinge
MAY ROBSON
Van Paul
Dorris Pawn
Hanneford
Leona Ball, Gertrude Glover, Renee Clements, Teddy Virgo
RICHARD HARDING
Col. Wm. F. Cody
Robt. Leonard
Robt. Chandler
Bryan Kysm
Patsy Forest
Charles Wellsley
Franklin Hanna
Hazel Sexton
Stewart Fisher
Selma Kilman
Al Cook
"Dot" Farley
Ben Finney
DANIEL SEGRAM
JANE COLLYER
ARTHUR HATCH
Gary McVeigh
Grant Stewart
Walter D. Mealand
Herbert Rice
Queen Pearl
Amy Manning
Carl Gordon
Joel Shore
Priss Holt
Mark Shore
Aaron Burnham
Curt Rehfeld
W.Y. Mong
Rita Norwood
Russell Carrington
Dorothy Wheeler
Herbert Norwood
Danny Hays
Ross Gunther
Bartley McCullun
S. Kennedy
Marshall Rickson
Margaret McComber
Fred Moore
Frank Richardson
Harold Brinkworth
Raj Singh
Tomar
Edna Brooks
Maid
Alice Butler
Mr. Butler
Frank Mathews
Mrs. Jennie Filson
Frances M. Gordon
T. Tammete
Frank Tremor
Dick Mason
Freckles
Master Holbrook
Sampolo
Col. Furlong
Margaret Murray Dees
Heloise Broulette
Leland Norton
Carter Vail
Mrs. Vail
Lil
Alice Vail
Mrs. Broulette
Louis Broulette
Frank Moore
FRANCES NELSON
Lewis Willoughby
Toto De Crow
Mrs. Lydia Titus
Rosa Pisley
Jimmy Finlayson
Nellie Savage
Donald Lashley
George Offerman, Jr.
John Packer
BILL DRAKE
Peter Guthrie
Betty Townsend
NICHOLAS KENYON
Rankin Townsend
Jack Riche
Eugene Field
Wm. Wadsworth
Betty Young
Ilma
Harry Drake
Perry Mason
Meda Brown
Harry Tracy
Emil Jorgensen
Mary Rolland
Emmet C. King
Filippo Ferrari
Johnny Duffey
Constance Talbot
Ray Van Twiller
Michael Callahan
Gladys Rullette
ANN WHARTON
TOM RANDALL
OLIVE WHARTON
GORDON TRENT
MR. WHARTON
MRS. BREDWELL
James Bradbury, Jr.
Fletcher Norton
H. A. Barrow
RUSSEL SIMPSON
FRANK THORWARD
Richard Randall
Beverley Randall
Tony Terle
Everett Dearing
David Warren
Mildred Juno
Kowpie Morgan
Irene Lantz
Dorothy Brown
Mr. Clark
Mr. Leary
Mrs Sidney Drew
Walter Emerson
End Gregory
Wilbur McGaugh
Tom Conley
Hattie 'Delaro
C. B. Murphy
Chas. Clary
Edward Arden
Emil Albes
Alexander Moissi
Heinrich Lux
John Gottowt
Otto Mattieson
Evon Pelletier
Tutor Owen
Fred Scott
Don Stewart
Mario Marjeroni
Corrine Griffith
John Picket
Yale Bemmer
Hal De Forrest
Martin Ferrari
Signor Zanfretta
MARGARET PRUSSING
HAROLD MELTZER
Richard Barthelness
E. G. Robinson
Luis Alberni
Jetta Gondal
Mr. Allen
Richard la Reno
Patricia Stanton
Hugh Stanton
Ted Madison
Mrs. Beatrice Madison
Victor Reymier
Andrea Mertens
Marie Mertens
De Brullier
Charles Bayer
Jack Johnston
Louis Deer
Frances Red Eagle
CHRISTIAN LYNTON
HORACE CARPENTER
JOHN ABRAHAM
GEORGE GEBHARDT
Violet Shramm
Patricia Parker
Silas Wainwright
Horace Kane
Emily Wainwright
John Wainwright
Maisie Morrison
Arabellas New
Jane New
Jimmie Barton
Barry Owen
Faith Fanshawe
Jeffery Jarvis
George White
Jerold Havener
Nancy Averill
Nan Jefferson
John Lane
Little Helen
Joe Blaney
Elsa Dorgan
Carlos
Frances Blaney
Mat Dorgan
Charles Gregg
“Bud” Osborne
Heinie C onklin
Tempe Pigot
Diana Elmonde
Genevieve Abbott
Mr. Shirley
E. A. Clark
E. J. Deneky
Wm. Ellenford
Corthothy Mackaill
Betty Adams
Ben Carnes
Will Adams
Bobby Adams
Zoe Gregory
Arthur Macklin
ESTHER GORDON
John Ray
HENRY AINLEY
TOM HARDING
DICK WOODS
MARGUERITE CLAYTON
Al. Cooke
John Graham
Fred G. Hearn
Edwin Stanley
A. E. Rainey
M. O'Conn
John Stopping
Harry Rhindman
Frank Nisely
Alic Howell
Sophie W
Emil Albee
Dorothy Dickson
Katherine Emmett
Lesley Hartman
ELMO LINCOLN
GEO. WILLIAMS
LEE KOELMAR
LOUISE LORRAINE
FRED HAMER
FAY HOLDERNESS
JENKS HARRIS
Inez Rojas
Roddy Forrester
Col. Vega
R.B. Forrester
General Rojas
Senora Rojas
Marlan Knight
Peter de Peyster
Dr. Vicenti
Sylvanus Godman
Manuel
El Commandante
La Borrachita
Genevieve Abbot
Roy Russel
Yvonne Gardelle
Dark Cloud
DOLLY GARDNER
BOB
Alice Vanni
Charles Mercedith
Ive Dawson
Lewis Broughton
JOE BONOMO
Lya De Putti
JULIA ARTHUR
Fred Knight
ETHEL GREY TERRY
DAN HANNON
GEORGE F. HAYES
CLARISSA SELWYNNE
JEANNE CARPENTER
MARION FEDUCHA
WILLIAM LOWERY
ANITA SIMONS
JAMES BARTON
Shirley Lord
David Quentin
Esther Summers
Jonathan Radbourne
Jim Blaisdell
Mrs. Blaisdell
Brown
Mandy Moore
Richard Holden
John Gallagher
Wilbur James
Dorothy Whiloby
\.


--
-- Data for Name: documents; Type: TABLE DATA; Schema: public; Owner: deh
--

COPY public.documents (id, copyright_year, studio, title, producer, writer, reel_count, series, uploaded_by, uploaded_time, document_type) FROM stdin;
s1229l24404	1927	Columbia Pictures Corporation	\N	\N	\N	\N	\N	\N	2026-04-16 22:36:07.799844	\N
s1229l16674	1921	Metro Pictures Corporation	VIOLA DANA A ROMANCE EMBROIDERED ON GINGHAM in “HOME STUFF”	\N	Frank Dazey and Agnes Johnston	\N	\N	\N	2026-04-16 21:46:07.880681	synopsis
s1229l17205	1921	Fox, William, 1879-1952	\N	\N	\N	\N	\N	\N	2026-04-16 23:41:40.351427	script
s1229l11157	1917	Thomas A. Edison, Inc.	THE LITTLE CHEVALIER	\N	M. E. M. Davis	\N	\N	\N	2026-04-16 23:16:43.061395	synopsis
s1229l11303	1917	Universal Film Manufacturing Company, Inc.	\N	\N	Mr. Jaccard	\N	The Red Ace	\N	2026-04-16 22:43:13.235625	synopsis
s1229l21540	1925	PathÃ© Exchange	Sunken Silver. Chapter 8 “The Shadow on the Stairs”	\N	Frank Leon Smith	2	Sunken Silver	\N	2026-04-16 22:14:10.714969	synopsis
s1229l23074	1926	Fox, William	\N	\N	\N	\N	\N	\N	2026-04-16 23:34:10.420824	script
s1229l22593	1926	Universal Pictures Corporation	MY OLD DUTCH	\N	Arthur Shirley and Albert Chevalier	8	\N	\N	2026-04-16 22:35:50.575933	synopsis
s1229l02940	1914	Leading Players Film Corporation	LARSAN'S LAST INCARNATION	\N	\N	\N	\N	\N	2026-04-16 23:08:54.999116	synopsis
s1229l19504	1923	Regent Film Company	A Woman of Paris	\N	Charles Chaplin	8	\N	\N	2026-04-16 23:15:50.522855	synopsis
s1229l17130	1921	De Haven, Carter, 1886-1977	My Lady Friends	\N	Rex Taylor	6	\N	\N	2026-04-16 22:19:05.221957	synopsis
s1229l11259	1917	Fox, William	\N	\N	\N	\N	\N	\N	2026-04-16 22:02:33.994736	script
s1229l13275	1919	Steiner, William	\N	\N	\N	\N	\N	\N	2026-04-16 23:32:50.074599	script
s1229m02201	1922	Out of the Inkwell Films, Inc.	\N	\N	\N	\N	\N	\N	2026-04-16 22:48:36.034294	script
s1229l18102	1922	Universal Film Manufacturing Company	IN THE DAYS OF BUFFALO BILL	\N	Robert Dillon	2	IN THE DAYS OF BUFFALO BILL	\N	2026-04-16 23:31:26.028134	synopsis
s1229l15171	1920	Fox, William	\N	\N	\N	\N	\N	\N	2026-04-16 23:40:37.231629	script
s1229l16965	1914	Jesse L. Lasky Feature Play Company	THE MAN FROM HOME	Cecil B. DeMille	Booth Tarkington and Harry Leon Wilson	5	\N	\N	2026-04-16 22:41:41.869572	synopsis
s1229l17360	1921	Universal Film Manufacturing Company	The House of Intrigue	Albert Russell	Anthony W. Coldeway	2	THE SECRET FOUR	\N	2026-04-16 21:45:35.672594	synopsis
s1229l04677	1915	Biograph Company	HIS DESPERATE DEED	\N	\N	\N	\N	\N	2026-04-16 22:13:36.512556	synopsis
s1229l12792	1918	Fox, William	QUEEN OF THE SEA	\N	GEORGE BRONSON HOWARD	\N	\N	\N	2026-04-16 22:59:12.432355	synopsis
s1229l11989	1918	Vitagraph Company of America	THE OTHER MAN	\N	XXXXXX; Rex Taylor & Irma Whelpley Taylor	5	\N	\N	2026-04-16 22:25:36.238848	synopsis
s1229l00904	1913	Thomas A. Edison, Inc.	In the Garden	\N	William Brede	\N	\N	\N	2026-04-16 22:44:17.36619	synopsis
s1229m01626	1920	Ford Motor Company	LITTLE COMRADES	\N	\N	\N	\N	\N	2026-04-16 22:41:54.411836	synopsis
s1229l13781	1919	American Film Company, Inc.	TRIXIE FROM BROADWAY	\N	Agnes C. Johnston	5	\N	\N	2026-04-16 23:34:12.622965	synopsis
s1229l10358	1917	Rose, Florence	\N	\N	\N	\N	\N	\N	2026-04-16 23:18:44.52672	synopsis
s1229l16934	1921	Chaplin, Charlie, 1889-1977	THE IDLE CLASS	\N	Charles Chaplin	2	\N	\N	2026-04-16 23:38:09.203365	synopsis
s1229l05191	1915	Universal Film Manufacturing Company, Inc.	The Master Rogues of Europe	\N	\N	3	\N	\N	2026-04-16 22:04:31.95556	synopsis
s1229l03312	1914	Vitagraph Company of America	THE AGELESS SEX	\N	JOHN FRANCIS	\N	\N	\N	2026-04-16 22:06:59.331676	synopsis
s1229l08234	1916	Universal Film Manufacturing Company, Inc.	A FIGHT FOR LOVE	\N	W. B. Pearson	2	\N	\N	2026-04-16 22:33:40.980635	synopsis
s1229l06541	1915	Metro Pictures Corporation	The Song Of The Wage Slave	\N	ROBERT W. SERVICE, BARSE & HOPKINS, Publishers, NEW YORK CITY	6	\N	\N	2026-04-16 23:37:51.750516	synopsis
s1229l02269	1914	Apex Film Company	The Great Dock Disaster	\N	\N	\N	\N	\N	2026-04-16 22:47:50.563991	synopsis
s1229l17208	1921	J. W. Film Corporation	FOR YOUR DAUGHTER'S SAKE	\N	\N	\N	\N	\N	2026-04-16 23:18:58.876593	synopsis
s1229l14171	1919	Universal Film Manufacturing Company, Inc.	BILL’S FINISH.	\N	\N	1	\N	\N	2026-04-16 22:42:57.291258	synopsis
s1229l07069	1915	Essanay Film Manufacturing Company	THE EDGE OF THINGS.	\N	\N	\N	\N	\N	2026-04-16 23:37:44.266274	synopsis
s1229l17204	1921	Fox, William, 1879-1952	\N	\N	\N	\N	\N	\N	2026-04-16 23:40:57.93724	script
s1229l00460	1913	Thomas A. Edison, Inc.	The Dean's Daughters	\N	Bannister Merwin	\N	\N	\N	2026-04-16 23:17:14.620068	synopsis
s1229l16359	1921	Pathe Exchange, Inc.	The Sky Ranger	\N	\N	\N	The Sky Ranger	\N	2026-04-16 21:51:26.124735	synopsis
s1229l13443	1919	Pathe Exchange, Inc.	A SAMMY IN SIBERIA	Rolin Film Company	\N	\N	\N	\N	2026-04-16 22:20:33.320106	synopsis
s1229l16768	1921	Vitagraph Company of America	THE INNER CHAMBER	\N	CHARLES CALDWELL DOBIE	6	\N	\N	2026-04-16 23:38:54.916357	synopsis
s1229l19144	1923	Preferred Pictures, Inc.	THE GIRL WHO CAME BACK	Tom Forman Production	Evelyn Campbell	6	\N	\N	2026-04-16 23:02:45.705253	synopsis
s1229l04711	1915	Selig Polyscope Company	RETRIBUTION	\N	JAMES OLIVER CURWOOD	2	\N	\N	2026-04-16 22:01:29.099949	synopsis
s1229l05188	1915	Kleine, George	BARTERED LIVES. Photodrama in Four Parts	\N	\N	\N	\N	\N	2026-04-16 22:16:28.775119	synopsis
s1229l12866	1918	Haworth Pictures Corporation	The Temple of Dusk	\N	\N	\N	\N	\N	2026-04-16 21:45:32.785135	synopsis
s1229l08428	1916	Kleine, George	\N	\N	\N	\N	\N	\N	2026-04-16 23:11:39.066777	synopsis
s1229l06358	1915	American Film Company, Inc.	The Honeymooners	\N	\N	\N	\N	\N	2026-04-16 22:47:47.721555	synopsis
s1229l07794	1916	Triangle Film Corporation	HIS AUTO RUINATION	\N	Mack Sennett	\N	\N	\N	2026-04-16 21:36:04.950539	synopsis
s1229l03712	1914	Thomas A. Edison, Inc.	\N	\N	\N	\N	\N	\N	2026-04-16 21:44:22.538397	synopsis
s1229m00140	1914	Selig Polyscope Company	HARRY LAUDER SINGING "SHE'S MA DAISY"	\N	\N	\N	\N	\N	2026-04-16 21:52:39.97184	synopsis
s1229l05370	1915	Universal Film Manufacturing Company, Inc.	THE GOLDEN WEDDING	Frank Lloyd	John Fleming Wilson	\N	\N	\N	2026-04-16 22:57:01.355612	synopsis
s1229m02420	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-16 23:27:58.349643	script
s1229l17012	1921	Universal Film Manufacturing Company	BROWNIE'S BABY DOLL	\N	Alf T. Goulding	2	\N	\N	2026-04-16 21:35:03.348179	synopsis
s1229l05617	1915	Universal Film Manufacturing Company, Inc.	ONE—DEW	William C. Dowlan	Leonora Dowlan	2	\N	\N	2026-04-16 22:45:39.660771	synopsis
s1229l18315	1922	Arrow Film Corporation	PEACEFUL PETERS	\N	W. C. Tuttle	5	\N	\N	2026-04-16 23:32:50.632517	synopsis
s1229l07524	1916	Universal Film Manufacturing Company, Inc.	The Wise Man and the Fool	\N	\N	2	\N	\N	2026-04-16 21:50:03.07041	synopsis
s1229l11391	1917	Metro Pictures Corporation	Their Compact	Maxwell Karger	Albert Shelby Le Vino	\N	\N	\N	2026-04-16 23:34:47.977957	synopsis
s1229l05314	1915	Universal Film Manufacturing Company, Inc.	HIRAM’S INHERITANCE.	Allen Curtis	C. G. Badger	\N	\N	\N	2026-04-16 23:16:09.991078	synopsis
s1229m00714	1916	Essanay Film Manufacturing Company	M 714	\N	Wallace A. Carlson	500	\N	\N	2026-04-16 23:39:27.25104	synopsis
s1229m01403	1919	Universal Film Manufacturing Company	\N	\N	\N	1	\N	\N	2026-04-16 23:30:42.865303	synopsis
s1229l15233	1920	Universal Film Manufacturing Company, Inc.	A Villain's Broken Heart	\N	\N	2	\N	\N	2026-04-16 22:41:35.623839	synopsis
s1229l21046	\N	\N	THE BELOVED BOZO	\N	Mack Sennett	\N	\N	\N	2026-04-16 21:40:55.226845	synopsis
\.


--
-- Data for Name: error_locations; Type: TABLE DATA; Schema: public; Owner: deh
--

COPY public.error_locations (location) FROM stdin;
\.


--
-- Data for Name: flagged_by; Type: TABLE DATA; Schema: public; Owner: deh
--

COPY public.flagged_by (id, document_id, user_name, error_location, error_description) FROM stdin;
\.


--
-- Data for Name: genres; Type: TABLE DATA; Schema: public; Owner: deh
--

COPY public.genres (genre) FROM stdin;
comedy
drama
action
\.


--
-- Data for Name: has_character; Type: TABLE DATA; Schema: public; Owner: deh
--

COPY public.has_character (id, document_id, character_name, actor_name, character_description) FROM stdin;
781416ec-0a61-4d1d-9e9d-7333aa13c935	s1229l17012	BABY PEGGY	\N	BABY PEGGY is a little waif, without a friend in the world.
97494396-3f7d-4834-b49a-2d584b56f8f4	s1229l17012	Brownie	\N	Brownie the friend to the homeless, rescues her doll when she loses it.
a97959f7-568b-4650-a9b9-5cef609c6496	s1229l07794	Mack Swain	Mack Swain	Mack Swain is the big important citizen who gets into the toil of the laugh. He is comic, whether as the fond father, the victim of a "con" game or as a convict with a ball and chain.
525dc125-a1ea-48f8-8947-4abcd1a81720	s1229l07794	Harry Gribbon	Harry Gribbon	Harry Gribbon appears as a shyster attorney. He is a good foil to bluff, blustering Mack Swain. Gribbon is everything that is polished and suave.
cab43e0a-53a7-49d5-b54e-60ecd9aef875	s1229l07794	Julia Faye	Julia Faye	Julia Faye is the young giggling girl who imposes on "papa" Swain.
4b2d020b-cc37-4240-b115-bdd7bb99a30e	s1229l07794	Harry McCoy	Harry McCoy	Harry McCoy is the suitor.
570c4477-439c-4685-8eb6-20ba9c564e7c	s1229l21046	\N	\N	The proprietor's daughter is the object of affection for the beloved Bozo.
3b69c41e-816a-4072-a29b-c6c842bf2e3e	s1229l21046	\N	\N	The leading lady of a travelling theatrical company possesses pearls.
e747ed03-1a54-4410-849a-db401f4fb4c1	s1229l03712	\N	\N	She follows the train to the station, but on arriving at a railway station, she found her father and his father on their way to a distant town. The meeting added to her distress, and she fainted.
77dba597-1ff5-4b59-8c4b-d39cbdf1aa8c	s1229l03712	Mr. Verwick	\N	Mr. Verwick appeared as soon as her absence was noticed.
fcaef613-d3d5-4488-ada9-e2d5e2320180	s1229l12866	Akira	\N	Akira, a Japanese poet, is in love with Ruth Vale, an American orphan, raised by Akira's father.
b8dac475-8606-4fca-9537-ecbb212749fd	s1229l12866	Ruth Vale	\N	Ruth Vale, an American orphan, raised by Akira's father.
cc0beaed-7545-477b-9b39-d703cff83e95	s1229l12866	Edward Markham	\N	Edward Markham, a wealthy American traveling in Japan.
3fee7dca-0d2c-4d38-8a2c-da0f47dc79fd	s1229l12866	Blossom	\N	A child, Blossom, is born.
bb59058b-399d-4f34-af53-bf053ccf5249	s1229l12866	Adrienne Chester	\N	Adrienne Chester, an American adventuress.
fa1c8f6b-689c-470f-ad11-7a1ba72c927f	s1229l12866	Pembroke Wilson	\N	Pembroke Wilson, former lover of Adrienne.
4d227bb5-e30d-4aa8-a4ab-d49c671a9561	s1229l17360	Jim	\N	Jim slips to place on back of the automobile of Dalravian agents who are following him. Jim is shown going aboard the steamer and later fighting Reynolds's men.
49a65f27-2c8a-4e34-bc82-d5c108d714b6	s1229l17360	Helen	\N	Helen receives the envelope containing information about the oil field discovery and takes the boat to America with Walgrave.
5a4e000d-2b2c-41a3-9c12-5233e68f21d4	s1229l17360	Walgrave	\N	Walgrave takes the boat for America with Helen.
c8398617-0b83-4ba6-b6b9-616f8f1da320	s1229l17360	Prof. Martin	\N	Prof. Martin is a celebrated American geologist who discovers the location of the oil field.
c43c092e-8a84-42cf-95a1-30fbd9a9efdc	s1229l17360	Nadine Martin	\N	Nadine Martin is the professor's granddaughter. She is seen taking a bucket and later encounters Reynolds.
3bf0643c-06e9-4631-a7d4-ea29d95657d3	s1229l17360	\N	\N	The baby sister of Nadine Martin. She is left in the room while Nadine goes to the well.
cafa526d-06e0-44d7-9207-a737bbaf4099	s1229l17360	Reynolds	\N	Reynolds is the representative of a powerful syndicate of money interests, determined to get the secret from the professor.
9b6c151f-4295-4ca9-a368-c828f3fc9593	s1229l16674	Viola Dana	Viola Dana	Viola Dana stars as Madge Joy, the leading lady of a cheap road show, and later as a little rural girl.
ecfea885-21c9-4afe-a8ac-9f97cc807c31	s1229l16674	Madge Joy	Madge Joy	Madge Joy is the leading lady of a cheap road show, who finds herself stranded and eventually settles on a farm.
193569dd-f44c-4b67-beab-687c4c0968e1	s1229l16674	Tom Gallery	Tom Gallery	Tom Gallery is a handsome young farmer boy.
4a2baa9d-92bf-4aa7-af24-d660fc04240e	s1229l16674	Josephine Crowell	Josephine Crowell	Josephine Crowell plays 'Ma' Deep, a regular mother, who opens her heart to any sufferer.
04e95957-1d8b-44ce-8288-ea6bfee09eee	s1229l16674	Nelson McDowell	Nelson McDowell	Nelson McDowell plays 'Pa' Deep, who is described as austere.
74197c2c-ec74-4345-a99c-aef1dd5097c8	s1229l16674	Priscilla Bonner	Priscilla Bonner	Priscilla Bonner plays Susan Deep, a stagestruck girl who has run away from home.
b8291357-f876-489f-9597-eaf412b19ac3	s1229l16674	Robert Chandler	Robert Chandler	Robert Chandler plays Mr. 'Pat'.
b3ce43db-0625-47f3-ac27-e85e459f7f19	s1229l16674	Aileen Manning	Aileen Manning	Aileen Manning plays Mrs. 'Pat'.
ff15ab80-84a8-4b40-b140-45d18939c7bf	s1229l16674	Phillip Sleeman	Phillip Sleeman	Phillip Sleeman plays Jim Sackett.
38e283f5-dcce-4f0f-bcfb-b7aef682236b	s1229l16359	George	\N	George is clever enough to escape Dr. Santro and return June, safe, to her father. His heroic acti ons alter Prof. Elliott's attitude and convince him that George is a friend, and not an enemy. June also, forgives the young man for his audacity.
f37a9d1e-98bd-4fa9-9164-64d8891bf955	s1229l16359	June	\N	\N
2da011a8-6117-464f-b545-2c8c2d1613c2	s1229l16359	Dr. Santro	\N	Santro's second attempt to kidnap June succeeds. He also kidnaps George.
e1ffde33-f126-4b07-98e4-a1c488d1e531	s1229l16359	Prof. Elliott	\N	Prof. Elliott is convinced by George's heroic actions that he is a friend and not an enemy.
3c7c3fc5-e8d2-4c9c-8f15-9afdffc3f80b	s1229l16359	Tharen	\N	Tharen, whose sympathies are with George, becomes frantic when Santro tells her that the best that can happen is death--the worst is a life sentence to the chest.
e473c033-8c6f-4fcf-b57d-89902b4663f4	s1229m00140	Harry Lauder	Harry Lauder	Harry Lauder, the Scottish comedian, singing
8467d1f4-fe17-4c39-abc0-3bfba7827180	s1229l05191	Olga	\N	Olga, an adventuress
e1ffeaf6-e3a1-43fe-991e-97aaa2e042ed	s1229l05191	Peter	\N	Peter, Olga's accomplice
3c09ac14-958c-40b6-a853-740f896787d7	s1229l05191	Count Von Rade	\N	Count Von Rade, a wealthy nobleman
e367e7e1-a539-4acb-8127-32f1ccd310a4	s1229l05191	James Langtry	\N	James Langtry, an English chemist
a230b7ce-877d-4f41-a4b3-81abb96bdd17	s1229l05191	Count Feauchon	\N	Count Feauchon, a French nobleman
96a12a24-4c24-4ca8-b265-98ca81e092de	s1229l03312	\N	\N	He thinks his wife is all false and eighty-two years old. This is the astonishing hallucination a young husband has. He discovers that her beauty is entirely made up of artificial articles. Wigs, false teeth, "form plumpers" etc. He awakes sobbing pitifully.
c8271105-abae-4f5e-923c-e2f6540bc392	s1229l04677	Burleigh	\N	Burleigh, a rancher, is informed that the inspectors have condemned his cattle.
c9f51b9f-782e-4780-9741-63de67e35d51	s1229l04677	Grace	\N	His sister, Grace, rides out to meet her lover, Grant, a neighboring rancher.
c8f9a398-f712-4170-8f0c-05b4b63e6d4e	s1229l04677	Grant	\N	Grant, a neighboring rancher.
ea24e551-e463-4d78-983a-41142cad1137	s1229l04677	foreman	\N	Burleigh and his foreman... plan to steal their neighbor's cattle.
54f97eaf-1d61-4e48-997b-dd8f2b80e626	s1229l04677	Grant's mother	\N	Grant's mother, who becomes suddenly ill.
a8d153d4-81ff-4521-9500-e3a0033338b7	s1229l04677	mail carrier	\N	The mail carrier who comes loping along the gulch.
de730025-4f9b-4701-b27c-82dd380cbc46	s1229l04677	cowboy	\N	A cowboy who gives the mail carrier a lift.
4dd7213c-0380-42cf-b0c6-bd0233a3b47e	s1229l04677	postmaster and citizens	\N	The postmaster and citizens who are puzzled over their own mail sacks.
d734079d-8167-4c76-b1d5-db20db3429c2	s1229l04677	doctor	\N	The doctor who pronounces Grant's mother out of danger.
3a0a48fc-c57d-4851-ba3a-f4af04062c22	s1229l04677	halfbreed girl	\N	An inexperienced halfbreed girl, who, along with Grace, nurses the sick woman.
52ba363a-ee03-40ba-9644-e0eae39b355a	s1229l04677	sheriff	\N	The sheriff who is satisfied with Grace's story.
f369a7b4-eea7-4133-b48c-88ed703f836e	s1229l05188	Hesperia	\N	Hesperia, an artists model, and her twin sister, Pierrette, a singer, so closely resemble each other that they cannot be told apart even by their most intimate friends, and are able to impersonate each other at will. (Hesperia)
29d35f69-da5d-49ef-98de-1804bbc38971	s1229l05188	Pierrette	\N	Hesperia, an artists model, and her twin sister, Pierrette, a singer, so closely resemble each other that they cannot be told apart even by their most intimate friends, and are able to impersonate each other at will. (Pierrette)
8a470782-78b9-45e5-b9fa-327b3d324693	s1229l05188	\N	\N	A young painter
a02e96fe-ec5a-45d4-ac89-0b7038e6ac68	s1229l05188	\N	\N	A millionaire
16e953de-da9c-4b35-aabb-1181b91ece1f	s1229l05188	\N	\N	A wealthy banker
12eacfd9-93ac-4926-bada-ab6df5fd3a6d	s1229l17130	James Smith	James Smith	James Smith was possess[ed] of a laudable desire to spend the millions he had acquired making Bibles...
ee161971-7009-40e6-8386-504bdc912852	s1229l17130	Mrs. Carter De Haven	Catherino Smith	Mrs. Smith still remembered the old days when they were striving to make every penny count.
a22e4afb-a2d5-4d3b-b601-56b02e5d195a	s1229l17130	Edward Early	Edward Early	\N
5d0e6e24-d881-4d05-9596-2035a6b69e79	s1229l17130	Helen Raymond	Lucillo Early	\N
b5421a6c-0336-4c21-83d8-760b4c7d37d2	s1229l17130	Helen Lynch	Eva Johns	\N
22788725-0d22-4056-98a0-69306e52f711	s1229l17130	Lincoln Stodman	Tom Trainer	\N
dfc3f47e-69ae-46dd-9abf-9463c3f686e5	s1229l17130	May Wallace	Hilda	\N
7aa4322a-a20e-4eef-9254-c2f6eea264af	s1229l17130	Nora ) Hazel Nowoll	Isaacs	\N
3f1a421d-462d-4cc4-b7b0-d503c8b5af0a	s1229l17130	Clara Morris	Clara Morris	Gwen ) Three Lady Friends.
542f42de-90d4-4167-ada8-0a85eeab13a8	s1229l17130	Ruth Ashby	Julia	Julia ) Ruth Ashby
db7f2f07-3d78-47c7-a634-56266b4fb23c	s1229l11989	John Stedman	\N	John Stedman compels a divorce and remarriage, abandons his practice as a surgeon in Philadelphia, and disappears
e71052a6-1b28-4d93-9cfa-5ab0db6d1e6f	s1229l11989	Dorothy Harmon	\N	a new servant; who is really an heiress, Dorothy Harmon in the slums on a bet
290e05e4-3436-4636-928c-958797008d09	s1229l11989	Mrs. Canfield	\N	his former wife back from abroad, where her second husband died
0b0e7306-a672-4e0b-94de-9b60f77a181c	s1229l08234	Marsico Napoli	G. Raymond Nye	Marsico Napoli, a right-hand man of the Camorra Chief.
36db38fe-ce70-42f2-9b45-15cd508c887a	s1229l08234	Gracia	Roberta Wilson	Gracia, the Lieutenant’s daughter.
5d3bab6d-0be9-4528-8e7d-fd5f1c3a49aa	s1229l08234	Chief Basista	J. De Rosa	Chief Basista
dfe7c8ff-b499-4309-b042-78d98b314695	s1229l08234	Pola	Hector V. Sarno	Pola
6e8f7733-3593-439a-a82d-25e2b65fd6e7	s1229l16965	Daniel Veorese Pike	Charles Richmond	Daniel Veorese Pike is a promising young attorney in Kokomo, Ind. He has a keen sense of humor, and whatever he undertakes he succeeds in accomplishing. His greatest interest in life, however, is Ethel Granger Simpson, the sweet and attractive young daughter of Adam Simpson, a fabulously wealthy old white haired gentleman, whose love is divided between Ethel and his son Horace.
95cf8d3d-b485-491c-a86e-33e1b71aa2aa	s1229l16965	Ethel Granger Simpson	\N	Ethel Granger Simpson, the sweet and attractive young daughter of Adam Simpson, a fabulously wealthy old white haired gentleman, whose love is divided between Ethel and his son Horace.
bdbc98cb-3d9f-4e88-929f-0c4bec21dc6f	s1229l16965	Adam Simpson	\N	Adam Simpson, a fabulously wealthy old white haired gentleman.
718bfb88-ffbf-4251-86e9-bbd0f46073cd	s1229l16965	Daniel	\N	Daniel always so happy to see Ethel that he will not heed her half hearted entreaty to refrain from a caress, although he respects her modesty enough to shield her from the passerby on the road, with his hat when he enacts a kiss.
a19ac99c-96c4-4f66-b8c6-341831e7b74a	s1229l16965	Ivanoff	\N	Ivanoff, a large sturdily built man with curly hair, is in the employ of the Russian Government.
6bca91e1-db6f-469b-a355-e5c88487c9d4	s1229l16965	Helena	\N	Helena, a tall slender woman, selfish and eager for wealth and social prominence.
e96da1cf-bcd7-435e-9d32-d309b863249c	s1229l16965	Hon. Almeric St. Aubyn	\N	The Hon. Almeric St. Aubyn, a foppish son.
9c282815-bb5d-4b53-98ac-f5acc177a215	s1229l16965	Grand Duke Vasilii Vasilievitch	\N	The Grand Duke Vasilii Vasilievitch, of Russia, who comes to Sorrento incognito for a rest.
7e004dbf-9dff-4b2b-baab-88b940f1d17e	s1229l11303	Virginia Lee	\N	Virginia Lee, daughter of an American mining man, is attending a fashionable bazaar given for the benefit of the American Red Cross.
2e663ec5-3009-4c62-8ba8-a64d91a8757e	s1229l11303	Doctor Hirtzman	\N	Doctor Hirtzman, of a foreign Secret Service.
cf6f1d3a-c346-4c24-b4b2-5856e9555212	s1229l11303	Patrick Kelly	\N	Patrick Kelly, travel worn and weary.
f0f64512-0119-4d4b-b782-1a697f319f64	s1229l11303	Richard	\N	Richard, Virginia's brother, who is at the “Red Ace” Mine.
f6dec594-41a8-41c4-bbc6-7290a7a01cd0	s1229l11303	Inspector Thornton	\N	Inspector Thornton, of the Royal Northwest Mounted Police.
9bbaf324-b9dc-4f5b-be1e-97cde1001654	s1229l11303	Private Winthrop	\N	Private Winthrop, who is instructed to carry out the orders by Inspector Thornton.
61bf75c9-52ef-4604-a893-c5549d838fe6	s1229l00904	Old Mr. Stevens	\N	Old Mr. Stevens finds a lover, at a dance, sulking because his sweetheart is kind to other men. To prevent two lives from being spoiled by mis-understanding, the old man tells the story of his own lost love.
98493c69-b0a5-4b77-9918-3ef636436b0f	s1229l00904	Stevens	\N	Stevens, a gallant young Southerner who was deeply in love with a girl, Julia.
7ad93ddf-8f59-44f7-82d5-c63b6eecd9f5	s1229l00904	Julia	\N	A girl named Julia, who was deeply loved by Stevens.
8595dcc0-a934-46c2-ab6f-518ba2beb5aa	s1229l00904	\N	\N	The young man's sweetheart who appears at the end, radiant and lovable in her youth and beauty.
fc6a576a-5044-4757-b773-6cd02172d621	s1229l05617	Billy Lawrence	Billy Lawrence	Billy Lawrence does [...]
12fed66e-11ba-415c-8a83-b6211c9f18d6	s1229l05617	Tobias Smith	Tobias Smith	Tobias Smith does [...]
741c7c97-0f7f-43e3-92b0-a614ede8ee03	s1229l05617	Carrots	Eugene Walsh	Carrots does [...]
756f76f4-5e67-4314-a850-6aeb984aead4	s1229l05617	Daisy Lawrence	Violet MacMillan	Daisy Lawrence does [...]
fc678b1b-99cb-41b7-aaa7-be3ce2ccdcd3	s1229l05617	Mrs. Brooks	Lule Warrenton	Mrs. Brooks does [...]
2934837b-5ef7-47e7-915e-20cff3e31373	s1229l05617	Vera Lawton	Carmen Phillips	Vera Lawton does [...]
39c3e7ab-28cc-405f-9f4b-430363c1e521	s1229l05617	Mrs. Gray	\N	Mrs. Gray does [...]
6634d016-b76a-4e4a-a1d1-4da0be94b9b4	s1229l05370	Daddy Manley	Charles Darling	Charles (Daddy) Manley does [...]
a3db3891-cfad-44fb-9aa9-019ddc93aba1	s1229l05370	Mother Benson	\N	Jane, his wife does [...]
1998a149-6489-440e-8d5e-28ca43e53839	s1229l05370	The star	Marc Robbins	The star does [...]
40a25342-4076-4b63-b732-3147c6ec6a05	s1229l19144	Sheila Weston	\N	Sheila Weston, an unsophisticated country girl who is unfortunate in her city associates.
55f2b875-b50e-4ded-869a-58409ec5bf54	s1229l19144	Ray Underhill	\N	Ray Underhill, who dazzles Sheila and is later arrested as an auto thief.
9614cb8c-72d9-4234-8e3a-2ec74f8114b2	s1229l19144	648	\N	“648,” a trusty, and a man “framed” in a bogus trust company deal.
654ab53f-2f9e-4368-beba-009af02b729b	s1229l19144	555	\N	“555,” a lifer, who speaks with old “648”.
f5591fd4-6469-48f6-b039-7c99b576f20a	s1229l19144	Ramon Valhays	\N	Ramon Valhays, the man responsible for “648’s” conviction.
0773c1ca-0868-49f6-9433-7fd269f82537	s1229l02940	Mathilde Stangerson	Mrs. Van Doren	Mathilde Stangerson married Larsan, an escaped convict. She thereupon exiled herself in Europe, to hide her sorrow, and there met Robert d'Arzac, a young professor at the Sorbonne, learned and courteous.
a6d6a8c3-75e1-4eb1-a776-770b44be7512	s1229l02940	Larsan	Mr. Garat	Larsan, an escaped convict who is Mathilde's husband. He is a bandit.
6ed1f095-bb43-44dd-9988-34644f6db57c	s1229l02940	Robert d'Arzac	Mr. Garat	Robert d'Arzac, a professor at the Sorbonne, who is Mathilde's beloved. Larsan impersonates him.
df39bd23-f73b-4bed-8983-b85421cd91b1	s1229l02940	Joseph Rouletabille	Mr. Jacques de Feraudy	Joseph Rouletabille, a reporter and intimate friend of the Stangersons and d'Arzac.
77006e91-a8a0-45f2-ae96-3c745f0db4d7	s1229l02940	Brignolles	\N	Brignolles, Robert d'Arzac's assistant. Larsan uses his alias.
9f444428-c486-42fd-9843-eb626568015d	s1229l08428	Miss Burke	\N	Miss Burke herself, as prologue, speaks the lines up to date, while dressed as a clown, or Pierrot, introducing father, Pierpont Stafford, the great banker; her brother David, his wife, her fiance, Richard Freneau, and Drs. Royce and Wakefield.
e14ce867-4533-45f4-9a15-5603d771008d	s1229l08428	Pierpont Stafford	\N	father, Pierpont Stafford, the great banker
8878b4f5-48bb-42db-b732-7ae8ac83e5ac	s1229l08428	David	\N	her brother David, his wife, her fiance, Richard Freneau, and Drs. Royce and Wakefield.
1c08ffe5-c8da-42c9-b92b-d3809d3004d4	s1229l08428	Richard Freneau	\N	her fiance, Richard Freneau
8862cba2-4613-4ba3-89f2-7cee08bc94f2	s1229l08428	Drs. Royce and Wakefield	\N	Drs. Royce and Wakefield.
f1b495ec-1ca1-44e1-9040-063e51e12b22	s1229l08428	Gloria	\N	Gloria's watch over her— with Dr. Royce, while her life hangs in Freneau, her fiance, is not allowed to see her, but brings care of Royce, who loves her, she becomes convalescent.
4e628926-8469-43d9-995f-ae6742d3306a	s1229l08428	Nell Trask	\N	Nell Trask, one of Freneau's victims, is hospital to which he has been taken after being auto.
f793f5c8-3445-4af3-87bb-9acbe236b5ad	s1229l08428	Sonia	\N	Sonia, whose love for the "Duke of Charmerace" does not cease when she discovers him to be Arsène Lupin, the thief
5a20f5b8-9ca7-47bb-872f-46eed801a304	s1229l08428	Arsène Lupin	\N	Arsène Lupin, the thief
cd89a88e-63ea-4b3e-800a-733ac77045f0	s1229l08428	Guerchard	\N	the triumphant detective at his side, Guerchard
44a03879-0182-4605-9723-d588599374ef	s1229l19504	Marie St. Clair	Edna Purviance	Marie St. Clair is young and unsophisticated, a victim of the environment of an unhappy home life in a village somewhere in France.
154bd4fb-d3e1-4128-9150-655a261130f1	s1229l19504	Pierre Revel	Adolphe Menjou	\N
a11e0a63-0c54-4ccf-8d5b-2ce137124dca	s1229l19504	John Millet	Carl Miller	\N
b5b674ce-52af-4a2d-8c54-2ca4a8391534	s1229l19504	His Mother	Lydia Knott	\N
ab617db4-907a-45b9-bcd0-e169cfad883d	s1229l19504	His Father	Charles French	\N
cb1fd3ae-08df-4c7d-b35e-7015c255cf68	s1229l19504	Marie’s Father	Clarence Geldert	\N
b5aef935-f6bc-4870-bfef-d6b87a66ba12	s1229l19504	\N	Betty Morrissey and Malvina Polo	Fifi and Paulette—Friends of Marie
5e07f493-ee7e-42c9-a94c-d48a4bb335a1	s1229l05314	Hiram	Max Asher	Hiram (Hi) loves Arabella. Hiram is bitterly sore.
9b0cdaef-47d1-4fe3-b007-87f33017f13d	s1229l05314	Arabella	Gale Henry	Arabella loves both Hiram and Zeke. Arabella settles things by accepting Zeke.
d62d3d86-6195-4588-b11d-f814e720d1f1	s1229l05314	Zeke	William Franey	Zeke loves Arabella. Zeke is left in the cold.
ea3f05df-6d15-46cf-9669-ccba8d80d449	s1229l05314	Tillie	Lillian Peacock	Tillie has long and secretly loved Zeke. Tillie is delighted with the present turn of affairs.
2d4a4256-fdf0-4572-b6f2-0fb6646f25c9	s1229l11157	Henry	\N	Henry, son of the slain Count of Valdeterre
a3ca4f94-fc29-4511-8447-4bf27ddc398d	s1229l11157	Chapron	\N	Valdeterre's devoted old servant
f2b8971d-8fda-401c-b635-934061bfa943	s1229l11157	Dominick	\N	a member of the de la Roche household
afc03824-db8b-46d4-b335-5c959dfb1e7d	s1229l11157	Delaup	\N	secretary to the Governor of Louisiana
94eea8ee-649d-4a4f-9e0e-85dbcee53cf5	s1229l11157	Little Chevalier	\N	the 'Little Chevalier' / Valcour de la Roche
2c7ac5c0-c6a5-4f54-9dd8-5e1cbdb66fc6	s1229l11157	Diane de la Roche	\N	The beautiful Diane de la Roche, daughter of the late Chevalier
b2fb155e-e7bf-4580-97d7-dd10ee4eeed6	s1229l11157	Valdeterre	\N	Vicomte de Valdeterre
091e0c0b-6376-4720-a8ef-1b835144de64	s1229l17208	Frederick Searles	\N	Frederick Searles, a financier who finds himself bankrupt.
dfa07613-cd88-4149-a90b-663d66190d34	s1229l17208	Mrs. Searles	\N	Mrs. Searles, Frederick's wife.
fc7b5369-1785-4fbc-97b2-3bf35653f840	s1229l17208	Needa	\N	Needa, the older daughter, beautiful and marriageable.
38159a8a-c986-4d6b-a0e7-294295e23f48	s1229l17208	John Davis Warren	\N	John Davis Warren, a powerful figure on Wall Street.
eecf2a6f-ea87-4547-a73b-5edf705ef6b2	s1229l17208	Hugh Stanton	\N	Hugh Stanton, the man Needa loves, who salvages torpedoed ships.
88708e89-46b5-476d-a721-78402aad73d7	s1229l17208	Ethel	\N	Needa's sister, Ethel, whom Needa saves from a fatal marriage.
200d89ff-b6e1-42cb-b110-09ecbc2a7145	s1229m01403	\N	Lillian Russell	Lillian Russell shows you how smiles increase your beauty
7b83e8d8-c375-4119-bffe-de6f53b308c8	s1229m01403	\N	Sig. Falconi	Sig. Falconi shows you how to read your lover’s character
0e0bf672-4ebf-43b7-aad2-d98af29b03bb	s1229m01403	Dad Watson	\N	old Dad Watson, the eighty-year-old bear hunter of the Cumberland Mountains, is showing you how young he is
ca67715e-beef-4c83-bc56-61129cd63ec2	s1229m01403	\N	\N	our own parlor chemist shows you how to make ordinary window glass
8f8ab31d-6b78-4aa4-a18d-dc7ac50fc781	s1229m01403	\N	James J. Corbett	a futurist portrait of James J. Corbett, Universal star
cc9dc3be-762a-46f5-84ef-45b87e23f62b	s1229l18102	Calvert Carter	\N	Calvert Carter, a southern veteran of Civil War is entering the great west beyond the Mississippi, by prairie schooner, to find a new home for himself and daughter, Alice.
e1b4ede8-22e3-4fc6-8cf7-42a99226f382	s1229l18102	Alice	\N	Alice, Calvert Carter's daughter.
c4bcf15f-0c8f-4fd0-9d80-ffe846074c11	s1229l18102	Art Taylor	\N	Art Taylor, pony express rider.
d16a0a8f-c478-4041-9d68-c8b9ca7862bd	s1229l18102	Buffalo Bill	\N	Bill &and Cody, later famous as Buffalo Bill.
63baa507-a0e3-4846-bf29-29392a18d0f5	s1229l18102	General Granville M. Dodge	\N	General Granville M. Dodge, chief engineer of the U.P.
0d5503a5-3a54-42fc-af02-1698d0679b1c	s1229l18102	Lamber Ashley	\N	Lamber Ashley, the agent of the mysterious eastern interest.
b282e579-fd79-446d-a397-0bb1538cd441	s1229l18102	Thomas C. Durant	\N	Thomas C. Durant, chief contractor and vice-president of the Union Pacific Railroad.
e762cfa6-dfd0-436d-a31a-7e1caca1c909	s1229l11391	James Van Dyke Moore	JAMES VAN DYKE MOORE	James Van Dyke Moore goes West to forget the havoc an evil woman has wrought in his life. He operates a silver mine. He is saved by Mollie Anderson. He is later wronged by his friend Robert Forrest, and eventually finds happiness with Mollie Anderson.
e2b10ed8-8352-4a77-aaca-7bdadaa73dff	s1229l11391	Mollie Anderson	Mollie Anderson	Mollie Anderson is pretty and helps Moore in a 'night-battle' for the mine's possession. She later helps Moore when he is captured.
33de65ae-2644-4843-9ac7-d5671e762ec7	s1229l11391	"Ace-High" Horton	FRANCIS X. BUSHMAN	"Ace-High" Horton has been stealing ore from Moore's mine. He later betrays Verda and attempts to sacrifice her.
b7c2af9f-e7a1-426d-b433-ed5facfcdd6b	s1229l11391	Robert Forrest	Robert Forrest	Robert Forrest brings his bride from the East. He becomes Moore's best friend but later suspects him.
7ff2fbdc-4d99-4b71-9b30-59d5171589f7	s1229l11391	Verda Forrest	Mildred Adams	Verda Forrest is the woman Moore came to forget, who is later revealed to be the wife of Robert Forrest.
706aaa1a-a71a-4b2c-9bed-05748566bf85	s1229l11391	"Pop" Anderson	Robert Chandler	"Pop" Anderson is a character mentioned in the cast list.
e16f54b1-6154-4014-82f4-a5640bebdc25	s1229l06541	Rev. Francis Pettibone	George MacIntyre	Rev. Francis Pettibone
b5b59ae5-a455-4021-9bed-0c7b1a77b2f5	s1229l06541	Ned Lane	EDMUND BREESE	Ned Lane, a worker in a great paper mill and a man of unusual strength and nobility of character, loves Mildred Hale, a poor girl, whose father is employed in the same mill.
98a9ee29-8f85-4ff4-8603-b7cdc6c871b0	s1229l06541	Mildred Hale	Helen Martin	Mildred Hale, a poor girl, whose father is employed in the same mill.
5fda4a31-1411-4de5-a26d-aaf8306707f4	s1229l06541	Andrew Hale	J. Byrnes	Andrew Hale
deb16392-c8bd-44a6-a521-88fc1e47993f	s1229l06541	Frank Dawson	Fraunie Fraunholz	Frank Dawson, the dashing young son of the millionaire manufacturer, who owns the mill.
3379034c-99fd-44de-afb6-d192715cfd73	s1229l06541	Edwin Dawson	Albert Froom	Edwin Dawson
86227c5e-f155-4bb5-a8e8-6f9afc647fab	s1229l06541	Talek	Wallace Scott	Talek
68e7de57-a30a-4bcc-b0fd-471b6023a2f7	s1229l06541	Mrs. Talek	Mabel Wright	Mrs. Talek
b41951d0-807e-44f3-a043-27b148288a98	s1229l06541	Neda	Claire Hillier	Neda
e9f1eb57-3e27-4ee3-b6fc-347cc85009be	s1229l06541	Alice	Kitty Reichert	Alice
132dc849-6cf5-463c-b724-44eb8e1caf53	s1229l06541	Sims	William Morse	Sims, an agitator
2612ee28-cd7a-4bf7-b59e-e7b6a597a0d4	s1229l16934	The Tramp	Charles Chaplin	The Tramp does [...].
58bbfa8c-10f7-4159-af02-3f4bbd24c2da	s1229l16934	The Absent-Minded Husband	\N	The Absent-Minded Husband at the hotel has been preparing to meet his WIFE, but some thirty minutes late.
e8b76346-9d33-4961-ace7-d420e6c3fe70	s1229l16934	His Wife	Edna Purviance	The WIFE, attended by maids and porters as befits her position and consequence. ... she has gone out on horseback to forget her husband's outrageous conduct
66aaa53c-678b-466b-be90-a7fc42142ff2	s1229l16934	The Angry Father	Mack Swain	The Angry Father takes a hand in the fray
8b89c8c8-fe2a-420d-b6d8-b40dbb804265	s1229m00714	Lifer "McNutt"	\N	Lifer "McNutt" has his record drive spoiled when No. 968 gets his head in the way.
a42ed0db-1dfc-4c89-9141-96bcb0acc665	s1229m00714	Luther "Leatherlungs"	\N	Luther "Leatherlungs" is caught by the camera as he delivers a speech on "Preparedness".
118cd2be-83a1-482d-be11-fbeff7f43788	s1229m00714	Dreamy Dud	\N	Dreamy Dud tries a trip in a submarine and blocks all the traffic on the ocean.
\.


--
-- Data for Name: has_genre; Type: TABLE DATA; Schema: public; Owner: deh
--

COPY public.has_genre (document_id, genre) FROM stdin;
s1229l17012	comedy
s1229l07794	comedy
s1229l21046	comedy
s1229l03712	drama
s1229l12866	drama
s1229l17360	action
s1229l16674	drama
s1229l16359	action
s1229m00140	comedy
s1229l05191	drama
s1229l03312	comedy
s1229l04677	drama
s1229l05188	drama
s1229l17130	drama
s1229l11989	drama
s1229l08234	drama
s1229l16965	drama
s1229m01626	drama
s1229l11303	action
s1229l00904	drama
s1229l05617	drama
s1229l05370	drama
s1229l19144	drama
s1229l02940	drama
s1229l08428	drama
s1229l19504	drama
s1229l05314	comedy
s1229l11157	drama
s1229l17208	drama
s1229m01403	drama
s1229l18102	drama
s1229l11391	drama
s1229l06541	drama
s1229l16934	comedy
s1229m00714	comedy
\.


--
-- Data for Name: has_location; Type: TABLE DATA; Schema: public; Owner: deh
--

COPY public.has_location (id, document_id, location, description) FROM stdin;
1faaa311-a34e-4b84-a547-3bf642ea8884	s1229l17012	woods	\N
d50b405d-e307-40dc-9840-19c1f13e76d4	s1229l07794	Triangle	Comedy
052543b0-5a33-44e8-9110-d7df60e19b62	s1229l07794	Mack's mansion	\N
8b0e3670-0673-4807-a679-35fac348ae2d	s1229l21046	small town	\N
343814e0-4a03-4d29-840a-3ab641cf4c31	s1229l21046	hotel	The only hotel where the crooks crash.
2a95b4f5-0ada-49cb-8c09-27bee1f2476f	s1229l03712	Reggie's wedding	It was at Reggie's wedding that the marriage of her sister, whom she had known since childhood, was announced.
65e6924d-09ef-4632-bcb0-953e61d470bd	s1229l03712	station	She followed the train to the station, but on arriving at a railway station, she found her father and his father on their way to a distant town.
51746b32-1abc-4d12-8e9a-f25a2c92ed85	s1229l12866	Japan	Location where characters are initially set.
500bd85a-a353-4f4b-b7a9-0a65ebba3412	s1229l12866	America	Location where Markham and Adrienne move after marriage.
aeb5b6d6-aad9-4db1-99fb-9d90787f5c5e	s1229l12866	house	A house where Wilson is found and later where Akira returns to help Blossom.
c9854dd4-8446-426e-89a5-06d7ef9e9c05	s1229l12866	garden	Location where Akira and Markham find Blossom in a storm.
6f14170e-a403-400b-9340-cda59e5f07c5	s1229l17360	pier	The pier where the steamer is about to depart for America.
dc2fe2fd-0edb-4cf1-906b-26bce8f44a60	s1229l17360	cot-tage	The humble cot-tage of the old professor.
7bfff08c-1568-4c09-b2be-7c7f4e8bf13e	s1229l17360	well	The old well outside the professor's house.
d73cd829-80c6-4c64-b12d-c8c5008985d1	s1229l17360	living room	The room outside the cabin where Nadine slams the door and locks it.
daef3993-3e70-469c-9376-7e238f8317e8	s1229l16674	Buckeye Junction	A small town where the road show comes to a standstill.
e1e79339-08ae-4d8e-8210-f5f51619fb19	s1229l16674	farm	A cozy farmstead where Madge ends up staying with the Deep family.
011c0d95-dba1-4b45-ad27-d03685edbd4a	s1229l16674	Deep homestead	The home of the Deep family.
15ed92f7-92e9-4d23-9cc0-268c782fd297	s1229l16674	magnolia farm	A picturesque old farm near Whittier, Calif., used for filming.
5e7eb55b-dcfa-45d3-8103-ed794ccabd74	s1229l16359	\N	a wind-swept plain in an obscure little country in Asia
29bb2f4a-5403-46e8-92ed-106d72063807	s1229l16359	inn	an inn in a nearby town
4180f806-57af-4967-a623-dc48642f5cd8	s1229l16359	\N	the temple of justice
b598e985-a299-41f6-bdfc-8b886e260bcc	s1229l05191	European settings	The film is staged in European settings.
7f51885f-cb2e-4109-b570-3f7ea8da2f59	s1229l05191	Russia and England	The scenes in the drama were filmed in Russia and England.
6e4ad2c4-110f-4fd4-8726-0d5ce98a7443	s1229l05191	Alexis bridge	The neighborhood where the robbery occurred.
768410fe-ad05-46f9-82e4-77d77f77d4a3	s1229l05191	Olga's home	The police throw a cordon around her home.
f890b950-2851-435f-8518-2b2655910dd7	s1229l05191	Hospital	Langtry takes the stupefied nobleman to a hospital.
50ffdf0a-fa91-4c03-9548-595dddad2ae2	s1229l05191	Country road	Olga is taken along a country road together with other political offenders.
60b61d14-19dc-4158-b9d1-8eda2826dac3	s1229l05191	English watering resort	Olga and Peter repair to an English watering resort.
1362f3b6-efc0-4287-a79c-940d89ce4932	s1229l04677	ranch	Where Burleigh and Grant are located.
3973381c-b72d-4fc5-8a20-dcbe6cb6c5a3	s1229l04677	barn	Where Grant goes to saddle his horse.
2b4eddcf-b08d-49ed-8978-dc88d5ce33ce	s1229l04677	gulch	Where the mail carrier comes loping along.
39863078-e3cf-4ee6-8283-981f0bd3e853	s1229l04677	trail	The path Grant takes after acquiring the horse.
652fa171-8e99-473e-8903-8bd531d86e45	s1229l04677	post office	Where the mail carrier ends up.
f5cc3617-74ac-4f07-a9c7-90f95d0c840b	s1229l04677	house	Grant's house, where the mother is sick.
fa4ee276-eacb-4dcf-ba97-8ae6b6629e00	s1229l05188	\N	an artists studio
42e0be75-543f-4586-bbb5-2d9dccc6516a	s1229l05188	\N	abroad
cce62808-3b38-4680-83be-174bbd3b9e04	s1229l05188	\N	the banker's hospital
9201037a-dc0a-4543-8521-e5e0a12fb02f	s1229l05188	\N	Pierrette's mansion
0aaa66cc-1a7b-4f13-8c29-680e49cbfbbf	s1229l05188	\N	the city
aba15d35-94bf-49ae-81f0-3e7cb27993c3	s1229l17130	Atlantic City	The location where James went to spend his money.
981a0617-efe8-4e79-a8cc-23eecca269b0	s1229l11989	Philadelphia	where John Stedman abandons his practice as a surgeon
469e643a-671d-46ad-98d6-2222e5fc8f4f	s1229l11989	slums of New York	The search ends at a lamp-post in the slums of New York
02cdf1eb-2795-4ec9-88e9-d4358cc3008a	s1229l11989	boarding house	where West stays
9e01e1e3-0615-4021-a969-5ac17592161f	s1229l11989	hotel	where Dorothy, her aunt, and the doctor are staying
99dfe126-36d0-4950-a16d-3e8ae4d46c14	s1229l11989	City Hall	where he takes her
53859b6b-3c72-46e7-b685-e757d5bd5ad5	s1229l08234	Camorra Lodge	\N
3fe252f6-e62e-41a4-9a09-0df115ec65a9	s1229l08234	upper hall	A two-story building within the location where the fight takes place.
b7a0e728-8243-436b-8c29-a3156efc62e8	s1229l16965	Kokomo, Ind.	Where Daniel Veorese Pike is a promising young attorney.
9a2dc3a3-6817-4772-896e-60dcd02a7c89	s1229l16965	rural district in the States	Where the Simpsons live.
287f6136-3eda-4975-85c3-ad8b8144f183	s1229l16965	Sorrento	The location where Ethel and Horace are when they receive word from Daniel, and where various plot events take place.
cd0669ce-c64d-458b-bb34-e9c90b86a1b9	s1229l16965	Siberia	Where Ivanoff is working in the mines.
968e3e9e-8bde-46a0-92e6-a179ba402cdd	s1229l16965	Hotel Regina Margherita	The hotel where Helene and Lord Hawcastle, and Ethel and Horace are staying.
1d004f3b-4a95-454e-8fdf-0282a757c9f1	s1229m01626	\N	The setting where children who are anaemic, tubercularly inclined and sickly are given special attention, including a study room with slate and stylus.
e3f35bba-15b3-4d29-bc9c-f0e8c098db01	s1229m01626	The beach	A location that lends a hand in the recovery of the little comrades.
92c73302-eb43-4bfe-8a1e-1d526fa3df97	s1229l11303	Chester, Pa.	Shoofly Coal & Iron Co.
f0a78590-8faa-438a-9733-61554b1a9860	s1229l11303	the arena	\N
542ed1de-4742-4235-af5d-e25ce890ecfc	s1229l11303	the blacksmith shop	\N
fec368f2-53eb-4073-9edf-b79d11abc616	s1229l11303	the office building	Where Lilly and Bringley were lost in the wreckage after Charlie attacked.
fb141bdc-f418-44f3-a4c2-3b0f3a9f5dca	s1229l11303	fashionable bazaar	Given for the benefit of the American Red Cross.
1c4070c7-4455-4c78-aa6b-a5e0d4f8e09c	s1229l11303	Canadian train	A location where Virginia makes a race.
3de0ce55-1db8-436b-9ca6-79922a68d7aa	s1229l11303	the “Red Ace” Mine	\N
f21f17b1-27f0-47c6-b0bf-5ec5907ae7ec	s1229l00904	a dance	The setting where the initial interaction and the climax of the story take place.
c6b4803f-d560-4878-a77e-a10913db99dd	s1229l05617	University	Where Daisy is sent to study
906fd1a4-7cd4-4b96-9333-9bf952f70889	s1229l05617	Adjoining farm	The farm owned by Tobias Smith
08c7d4aa-6c3f-4f6f-9341-d1228f0b9d52	s1229l05617	City	Where Daisy is sent for university
37502e4e-7f91-4b75-9a4a-174f54ffcc0c	s1229l05370	\N	a door-keeper at a theatre
0a8a7923-1df6-4d78-9761-069d303d0fa9	s1229l05370	\N	theatre
ae1cf0b7-9c60-4aef-b370-ec8934f661f5	s1229l19144	dance hall	Where Sheila is dazzled by the lights and jazz.
edce2d4b-8345-49d4-91fc-483170c1da7a	s1229l19144	justice’s house	Where Ray and Sheila have the ceremony and are subsequently arrested.
fe28773f-371b-4449-8a61-effad9694b8a	s1229l19144	jail	Where Ray and “648” are held.
0352374c-e986-4add-96c3-063ff4064bb8	s1229l19144	house owned by “648”	Where Ray and “648” escape to and where “648” hides money.
a719fac1-9676-42bb-8692-a7a91525612b	s1229l19144	Sheila’s	Sheila’s residence, where she is followed and captured.
9765e3d2-318a-4fc0-b907-235e6a1b06ff	s1229l19144	Capetown	Where six years later, “648” (as Norries) and Sheila meet again.
a6d53f20-ce8d-49d7-a6c6-e875282af98e	s1229l02940	America	Where Mathilde Stangerson married Larsan.
70848282-1f5c-481d-9dc3-32303eb774dd	s1229l02940	France	Where Mathilde Stangerson returns to hide under her father's roof.
1b722f58-872d-4152-9e2a-862d568e4862	s1229l02940	Marseilles	Where Larsan lands secretly.
b2c88d95-e731-472d-b9e4-502c057f4886	s1229l02940	Sorbonne	The university where Robert d'Arzac is professor.
5041a83b-5974-4871-80c2-c398cfad9bb6	s1229l02940	Sanitarium of the Mont-Barbonnet, Sospel (Alpes Maritimes)	A sanitarium where d'Arzac is confined.
27fe378b-1ff9-4a3f-88ae-b45e3ad8a4c0	s1229l02940	Riviera	The location where Larsan and his victim travel after the presumed attack.
2b28d529-498d-43ba-bb8a-0b7c6d27171b	s1229l02940	Chateau "Hercules"	The mansion where the newlyweds are staying on their honeymoon.
bc8d50fa-2326-4bc6-a268-e8374b261783	s1229l08428	\N	River river and the surrounding country from her window
a1064a49-13a3-40a9-a7d5-f1074ae3eab2	s1229l08428	\N	Nell Trask, one of Freneau's victims, is hospital to which he has been taken after being auto.
f6a74d1b-6b06-4b65-8f15-49ebd7b631bb	s1229l08428	\N	Freneau in his own apartment
d7aa29b7-3aea-4f46-ac08-e3dee84905d7	s1229l08428	\N	prison van
d0bce0c4-0cf4-48ec-883a-331996d5ff79	s1229l08428	\N	police-station
17380361-aa2e-4e25-8b3d-99b17a0801ad	s1229l08428	\N	his prison window
3e072d5b-f52e-4950-9f82-72ea18d22450	s1229l19504	Paris	The setting for the story, including a boudoir and a cafe.
4a20c3a1-ba14-46cc-8e56-5077e6430d87	s1229l19504	France	The village where Marie St. Clair originates.
74f6eab3-9bcf-4428-b129-97395c741408	s1229l19504	Montmarte	A neighborhood where Marie is invited to a studio party.
d951bc61-8e79-44d5-978d-477185acb924	s1229l05314	the parson’s	Where Arabella and Hiram are married, and where Zeke and Arabella finally leave for.
989e59e5-a336-478c-a967-2ee30b6c3477	s1229l05314	river	Where Hiram goes down to drown himself.
4750bb25-ff5d-44d4-b805-08712a8dc600	s1229l11157	Louisiana	The far away colony of Louisiana
17bce8c6-5fdc-4776-aeeb-e1eb2c9fea56	s1229l11157	La Roche estate	The property of the La Roche family, where the duel and the garden scenes take place
acbd2ba3-332c-4937-958c-166f0ca3373b	s1229l11157	NEW ORLEANS	The setting in 1752
b7961b84-5fa9-4ab4-a8f4-0a37a3fdc720	s1229l11157	Governor's castle	The location where the ball is in progress on Twelfth Night
4e9f5eab-339c-4dea-ad2c-9e1971ff9ae5	s1229l17208	Wall Street	The setting for the financial difficulties of the Searles family.
db7c1472-3f2e-4b49-9dce-6bc45696763e	s1229l17208	Mr. Warren's yacht	Where Needa and Mr. Warren leave for a honeymoon cruise.
7f021ad9-9d58-4b2f-aa93-499b81729a50	s1229m01403	Ballybunion	located in Ballybunion, Ireland, and is only one of the picturesque features of the Killarney Lake region
c7dd7b41-bce6-4d4f-a134-540d8c86bff2	s1229m01403	Killarney Lake region	the region where Ballybunion is located
4e9ddcd5-5bc7-48ad-a5c2-b88c953d912a	s1229m01403	Cumberland Mountains	where Dad Watson, the eighty-year-old bear hunter is from
88c06030-e199-40b4-9764-5ce8fbbf6634	s1229l18102	the great west beyond the Mississippi	Where Calvert Carter travels by prairie schooner.
2ffbd9f8-fb75-4069-8730-fa46ae1ed004	s1229l18102	an abandoned shack	Where Calvert Carter and Alice take refuge.
7abcb65a-13aa-4382-bbf5-ab906e455b08	s1229l18102	Fort Kearney, Neb.	Where Art Taylor asks Cody to take his dispatches.
5de9270e-e988-4899-a0c3-3e3df54718ca	s1229l18102	General Dodge's office	Where intruders search for plans.
d9624017-178e-423a-89d8-a6c18c8f1f94	s1229l18102	The Carter house	The site of the proposed railroad junction.
2af93c3a-e6c9-4b3d-9c89-5bca2917e133	s1229l11391	West	The setting where James Van Dyke Moore goes to operate his father's silver mine and forget a past tragedy.
90dc55db-0ffd-4c41-8585-ece3385cdbb1	s1229l11391	The mine	A silver mine bequeathed to James Van Dyke Moore.
f25ed89e-eb33-40bd-8cac-a61424d1f35a	s1229l11391	Desert	A location where trouble awaits the fugitives, and where Verda is eventually escorted to.
df1c72c7-d935-4892-b11c-de8d6a105269	s1229l06541	\N	a great paper mill
0397f5fb-9d2c-44ce-8b2c-f5558b0126bd	s1229l16934	exclusive railway station of any exclusive community	where the WIFE is attended by maids and porters as befits her position and consequence.
e347e2a2-5fbd-4114-9c96-473aae52944a	s1229l16934	hotel	where the ABSENT-MINDED HUSBAND is staying and where the ball masque takes place.
c2d8fc90-df90-4f51-8481-2b999badb9ca	s1229l16934	golf course adjoining the hotel	where the TRAMP meets the WIFE.
a82e5b40-0abc-4bb0-8aeb-2e0ff7eeeeaa	s1229m00714	Sing Song, N. Y.	A prison where the film shows the pleasures of being incarcerated and includes a golf tournament on the prison course.
\.


--
-- Data for Name: search_history; Type: TABLE DATA; Schema: public; Owner: deh
--

COPY public.search_history (id, user_name, "time", start_year, end_year, studio, actors, genres, tags, search_text, min_reels, max_reels) FROM stdin;
\.


--
-- Data for Name: transcripts; Type: TABLE DATA; Schema: public; Owner: deh
--

COPY public.transcripts (document_id, page_number, content) FROM stdin;
s1229l17012	3	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l17012	1	SEP 28 1921\n\n©CLL 17012  BROWNIE'S BABY DOLL\nPhotoplay in two reels\nWritten and directed by Alf T. Goulding\nAuthor, Universal Film Mfg. Co. Inc. of the\nU. S. as employer for hire
s1229l17012	2	CCL 17012\n\n“Brownie’s Baby Doll”\nTwo-reel Century Comedy\nStarring\nBROWNIE and BABY PEGGY\nDirected by ALF GOULDING\n\nBABY PEGGY is a little waif, without a friend in the world. When she loses her doll, Brownie the friend to the homeless, rescues it for her. Then a lifelong friendship is the result. Brownie and Baby Peggy find a pocketbook with a wad of bills in it. The wallet has been lost by a fab- bish dude who had secured it to his pocket by means of an elastic. The rubber band causes the billfold to snap back and hit the dude in the back every time Baby Peggy starts to walk off with it. Brownie cleverly severs the elastic by holding it against the rim of a knife-grinding wheel and brings the wallet back to Baby Peggy. The waif and her guardian, Brownie, see to it that the waif is outfitted in a new riding-habit, and then Brownie even goes so far and gets her a pony. After helping her on the pony they jaunt through the woods. Later, tiring of the horse (she gets thrown off—first) she drives an automobile, which happens to stand nearby. After a hair-raising escapade Baby Peggy finds it is all a dream.
s1229l07794	3	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l07794	2	©CIL 7794\nHIS AUTO RUINATION.\nBy:- Mack Sennett\n\nA burlesque on the ways of shady lawyers is presented\nwith many good laughs in the Triangle Keystone Comedy- "His Auto\nRuinatlon." Mack Swain is the big important citizen who gets\ninto the toil of the laugh. He is comic, whether as the fond father,\nthe victim of a "con" game or as a convict with a ball and chain.\n\nHarry Gribbon appears as a shyster attorney. He is a good\nfoil to bluff, blustering Mack Swain. Gribbon is everything that is\npolished and suave. With finesse he makes Mack think that he has\ncrippled a man for life and gets him t eed over his property.\nAnother time he takes Mack's family ou or an auto ride and brings\nout the humor of the situation when th head of the family is seen\ntoiling with a chain gang on some road work.\n\nJulia Faye is the young giggling girl who imposes on\n"papa" Swain. She cajoles him into letting her have money to buy\na new car, while he has to be satisfied with a second hand vintage.\nIt almost arouses the wrath of the doting parent while his wheezing\nvehicle has to take the dust of his daughter's car. Harry McCoy is\nthe suitor. Stern old Mack Swain objects to the dashing young blade's\nattentions to his child Julia. Then McCoy shows his craftiness.\nHe pretends to fall under the wheels of Mack's car. McCoy is taken\nto Mack's mansion where he soon recovers from his supposed injuries\nand makes ardent love to Julia. There is a big climax in the end.\nMack gets even with Lawyer Gribbon and is restored to his family\nand there is happiness to spare for one and all.\n\nMAR 10 1916
s1229l07794	1	L 77794
s1229l21046	1	JAN 19 '25\n\nTHE BELOVED BOZO\n\n© CIL 21046\nBy Mack Sennett\n\nTwo would-be crooks crash into a small\ntown with intentions none of the best. Seeking quarters\nin the only hotel - the beloved Bozo falls a victim to\nthe velvety-brown eyes of the proprietor's daughter. The\nBozo's pal, unaware of his partner's change of heart, puts\ninto operation a plan of his own to secure the pearls\n-possessed by the leading lady of a travelling theatrical\ncompany and is foiled at the crucial moment. Honesty proves\nthe best policy, the pals separate -- one to continue his\npath of iniquity alone, the other to the right path through\na change of heart.
s1229l21046	2	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l03712	3	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l03712	2	NOV 10 1914\n\nReleased, Nov. 23, 1914\n\n© C.I.L. 3712\n\n23\n\nIt was at Reggie's wedding that the marriage of her sister, whom she had known since childhood, was announced. The newly furnished house, with its range of matters that had been discussed, was a scene of great excitement. The people had kept their feelings under control until he was able to arrange matters differently.\n\nShe followed the train to the station, but on arriving at a railway station, she found her father and his father on their way to a distant town. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings under control until he was able to arrange matters differently.\n\nIn spite of her every effort, she was unable to keep the secret. The meeting added to her distress, and she fainted.\n\nWhen she recovered, she was attended by her father, who understood her condition. Mr. Verwick appeared as soon as her absence was noticed.\n\nThe news was entirely unfounded, as it was celebrated by them all on Thanksgiving Day.\n\nThe reconstruction upon which the people had kept their feelings
s1229l03712	1	L 3712
s1229l12866	3	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l12866	2	SEP -3 1918\n©CIL 12866\n\nThe title of the motion picture photoplay respecting which\napplication for copyright is herewith made, is as follows: "The\nTemple of Dusk."\n\nThe description of said photoplay is as follows:\n\nAkira, a Japanese poet, is in love with Ruth Vale, an\nAmerican orphan, raised by Akira's father. Ruth, however, marries\nEdward Markham, a wealthy American traveling in Japan. A child,\nBlossom, is born, but Markham soon tires of his family and is\nattracted by Adrienne Chester, an American adventuress. Ruth dies,\nleaving Blossom in the care of Akira, who is very much attached to\nBlossom. A little later, Markham and Adrienne are married and move\nto America, taking Akira and Blossom with them. Adrienne soon\ntires of Markham and receives the former lover,\nPembroke Wilson. Returning home unexpectedly on a business trip,\nMarkham finds Wilson at his home and kills him. To avoid disgrace\ncoming on the child's father, Akira gives himself up as the murderer\nof Wilson. While in prison, Akira gets word that Blossom is\nvery ill and breaks out, returning to the house to help her. In\nhis escape, he is shot, and on his arrival at the house finds that\nBlossom has disappeared. Akira and Markham search for Blossom and\nfind her out in the garden in a storm. After putting her back to\nbed, Akira is overcome by the effects of his wounds and dies at\nBlossom's bedside.
s1229l12866	1	L12866
s1229l17360	3	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l17360	1	DEC 14 1921\n\n©CIL 17360 e\nTHE SECRET FOUR\nPhotoplay in two reels\n√Episode #2 "The House of Intrigue"\nStory and scenario by Anthony W. Coldeway\nProduced by Albert Russell\nAuthor of the photoplay (under Sec. 62)\nUniversal Film Mfg. Co. Inc. of the U. S.
s1229l17360	2	DEC 14 1921\n\n© CIL 17360\n\n"The House of Intrigue"\n"THE SECRET FOUR" #8\n\nWhen the draw-bridge is turned\nplace, Jim slips to place on back of\nthe automobile of Dalravian agents\nwho are following him. Thinking he\nhas escaped to the steamship pier,\nthey speed there—just where he wants\nto-go.\n\nAt the pier, where the steamer is\nabout to depart for America, Jim\ngives them the slip and turns the en-\nvelope over to Helen, who finds it\ncontains the information that the oil\nfield had been discovered by Prof.\nMartin, a celebrated American geolo-\ngist. The Dalravians have planned to\nlearn the location of the field from\nhim and acquire a lease on them.\n\nBoth Helen and Walgrave, who does\nnot suspect her, take the boat for\nAmerica. Jim also goes aboard as a\nstowaway and reaches his native land\nin safety. Helen has won his promise\nto hasten and inform Prof. Martin of\nthe impending ruse.\n\nStoddard reaches the humble cot-\ntage of the old professor, who is just\nfinishing a chart or map of the oil\nfields, the directions pertaining to\nwhich are written in cipher below. The\ncipher is taken from a code book\nsupplied by a young woman known to\nhim as the agent of the U. S. govern-\nment.\n\nJim arrives in time to warn Martin\nbefore the arrival of Reynolds's agent\nof a banking group, also desirous of\nlearning the oil secret. Reynolds of-\nfers a vast sum for the secret, but\nthe professor refuses, from patriotic\nmotives.\n\nThe professor's granddaughter, Na-\ndine Martin, and her baby sister see\nJim order Reynolds from the house.\n\nOffered Fabulous Sum\n\nProfessor Martin then shows Jim an\nenvelope containing the great secret,\nand explains its importance and value.\n"It is the culmination of years of\nwork," he says, "and I have already\nbeen offered a fabulous sum for it, but\nto anyone who would use it for selfish\npurposes I refuse to sell it. To-mor-\nrow I go to return it to those by\nwhom I am employed." He does not\nsuspect that his employers are agents\nof Dalravia.\n\nIn the room outside Nadine rises\nand takes a bucket and leaves for the\nold well outside. The baby is left in\nthe room. Then Reynolds, the repre-\nsentative of a powerful syndicate of\nmoney interests outside the cabin, still\ndetermined to get the secret the pro-\nfessor refused to sell. Now, together\nwith one or two men who are with\nhim, he starts towards the cabin.\n\nWhile Jim and Nadine are talking\nNadine at the well sees Reynolds,\nwhom she knows as the man after\nher grandfather's secret and who is\nstill hanging around. His sudden ap-\npearance frightens her; she rushes\ninto the cabin and Reynolds starts\nafter her. Rushing into the living\nroom, Nadine slams the door and\nlocks it.\n\nJim and the old professor rush in.\nOutside Reynolds calls out assuring\nthem that they are in no danger if\nthey will but give him the secret the\nold professor has just written down.\nThe professor looks at the envelope\nhe holds in his hand and replies that\nit goes to no one but those who would\nuse it in the interests of this country.\nReynolds and his men rush the door\nas the professor slips the envelope in\nhis pocket.\n\nRealizing that they must escape,\nJim now calls to Nadine. He tells her\nto stand by the door and unbar it\nwhen he says the word. He swings up\non a rafter over the door, and calls\nto Nadine. She opens the door, Rey-\nnolds and his men rush in, and Jim\ndrops down upon them. A fight fol-\nlows.
s1229l16674	4	VIOLA DANA\nA ROMANCE EMBROIDERED ON GINGHAM\nin “HOME STUFF”\n\nLobby\nStills\n\n8 x 10\n11 x 14\n8 x 10\n\nYour Lobby\nAfter you have glanced\nover this variety of beautiful\nstills, and decided which will\nbest serve your purpose in\nmaking your lobby as artistic\nand forceful and peppy as\npossible, order them from\nyour nearest Metro exchange.\nThe assortment includes two\n22x28's, six 11x14's, and ten\n8x10's. The first two are\nbeautifully hand-colored, and\nthe smallest sizes are in sepia,\nwith the appearance of photo-\ngraphic portraits. Title and\nsynopsis cards accompany the\nstills.\nA good lobby display always\nbrings big box-office results.\nIt never fails.\n\nAbove and to the right are\nappealing 11 x 14's\n\nDid you ever see such a\nwonderful Still?\n\n8 x 10\n11x14\n8 x 10\n\n22x28's\n\n[PAGE FOUR]
s1229l16674	13	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l16674	8	VIOLA DANA in “HOME STUFF”\nA ROMANCE EMBROIDERED ON GINGHAM\nStunts To Get The Public Eye—Something For The Showman\n\nDECORATE LOBBY IN\nOLD FASHIONED WAY\nAncient Furniture And Picture\nFrames As Novelty Features\nFor “Home Stuff”\n\nFor the progressive showman, his\nlobby is a standing advertisement for\nhis house and the way he decorates it\nand the various schemes he makes use\nof to attract the attention of the public\nmakes it a center of interest for the\nthousands of people passing by.\nIf he goes to pains to make a lobby\ndisplay that will stand out, the appeal\nto those going by will be such as to\ndrag them inside, and once they are\ninterested enough to step in off the\nsidewalk, it is almost a certainty that\nthey will find enough attraction in the\ndisplays to make them want to come\ninside and see the show.\n“Home Stuff” is peculiarly adapted to\nmaking a lobby display which is bound\nto catch the eye of everyone and arouse\nwidespread interest. Its appeal to\nevery person lies in the fact that it\ndeals with the home that nearly every\none looks either forward or backward\nto and those who have no such expecta-\ntions or memories have their imagina-\ntion to draw upon in figuring out what\nthey think home stuff should be.\nWith such a wide field for exploita-\ntion the exhibitor can arrange a very\nattractive lobby setting picturing promi-\nnently the motherly feature of the home.\nThe lobby could be turned into a repre-\nsentation of an old-fashioned home\nwith the usual mottos and signs that\nexperience and fiction have made famil-\niar to most of the public.\nSome of the old-fashioned furniture\ncould be arranged about the lobby and\nbe so placed as to face the mottos\nwhich, while carrying the traditional\nsayings should also be hooked up to\nadvertise the showing of Viola Dana\nin “Home Stuff.”\nTo further heighten the general char-\nacter of the old home, the lobby stills\ncould be hung in those ancient picture\nframes which marked the dwellings of\nyears ago.\n\nViola\nDana\nOne-Col. Star Cut or Mat No. 59-L\n\nPrint Paper Bags With\nAnnouncement of Showing\n\nBakeries, restaurants and grocers, all\nshould be willing to give HOME\nSTUFF a boost during its showing at\nyour theatre.\nFor the bakeries, have a quantity of\npaper bags printed with the lines:\n\nJust Like Mother Used\nTo Bake\nBut there is all the rest\nof the\n“HOME STUFF”\nwith\nVIOLA DANA\nAt the RIALTO this\nweek\n\nIssue these bags free to the bakers\nand you will find that it will mean one\nhundred per cent. circulation for you\non this medium of advertising.\nThe home cooking angle can be\napplied to restaurants with equally good\nresults and they should be willing to\ngive you a display that will bring out\nthe HOME STUFF idea for all it is\nworth.\n\nPacking Them In\n\nWhen the long lines form before the box office and every\nseat in the house is sold, the showman knows that he has put\none over and is anxious to let others know about his success.\n\nMetro believes in that sort of thing and when the exhib-\nitor has scored on a picture, Metro stands ready to let the\npublic know about it. If you have gotten your crowds by\nsome stunt that would make a good picture, have the photo\ntaken and send the bill along with the story, direct to\n\nJ.E.D. MEADOR\nDirector of Advertising and Publicity\nMetro 1476 Broadway N.Y.\n\nModel Kitchen And Cook\nFor Window Advertisement\n\nGas and electric companies are always\nseeking new ways to display their mer-\nchandise to the housewives and present\nthe advantages of using the particular\nform of range, heater, toaster or other\nmodern device in such a manner as to\narouse the interest of the women folks\nand cause them to want to use the art-\nicle advertised.\nThese companies are usually glad to\ncooperate with anything that will fur-\nnish them a new angle for exploiting\nthe articles they have to sell. In “Home\nStuff” the showman has a wealth of\nmaterial which will make most effective\nadvertising when hooked up with the\nexploitation department of such com-\npanies.\nIt should be easy to arrange for a\nkitchen setting with a gas company,\nshowing the most modern devices for\nmaking the usual drudgeries of the\nhousewife a pleasure. The various\nways in which the gas range makes it\neasy to do cooking could be shown.\nA very attractive display can be\narranged by having a young lady attired\nin a trim kitchen costume, with all the\nmodern conveniences of an up-to-date\nkitchen forming part of the scheme of\ndecorations. The young woman could\nbe cooking various articles of food on\nthe gas and electric appliances, and, if\nthese pies, cakes, rolls, and other delica-\ncies are prominently displayed, there\nwill be no difficulty in getting an inter-\nested crowd about the window.\nIn cooperating with the company, the\nexhibitor will find it very easy to frame\nup attractive advertisements of his\nshowing bringing out the fact that\n“Home Stuff” is also being shown at\nhis theatre with Viola Dana as the\nstar.\n\nHave Novelty Stickers To\nAdvertise “Home Stuff”\n\nA sticker gets the eye of everybody\nbecause it is usually novel in form and\neasy to read, presenting its message to\nthe busy passerby in a terse manner that\nmakes it easy to get across.\nFor “Home Stuff” attractive stickers\ncan be prepared, as since the prohibition\namendment has been operative, the\nquestion of home stuff has been a very\npertinent one and one which has\nreceived all kinds of publicity. By play-\ning upon this feature of home stuff\nyou can make your stickers get the\ninterested attention of everybody.\nThe sticker could state:\n\nIf You Want\nPlenty of\n“HOME STUFF”\nsee\nVIOLA DANA\nIn Her Latest Picture\nAt the . . . . . Theatre\n\nGet your boys to paste these stickers\non autos and around the town, as they\nwill serve to widely advertise your\nfeature.\n\nHave Bachelors Judge Home Stuff\n\nEvery girl is more or less proud of her ability to do things around the house, either bak-\ning, sewing or some other of the thousand and one things that can be listed under the heading\nof home stuff. In fact, the number of girls who are not able to do something around their\nhomes is so few that they are hard to find.\nThis particular home trait of girls offers the exhibitor a splendid chance to do some\nnovelty exploitation for “Home Stuff” that should attract the interest of not only a large\nsection of the population, but also afford excellent material for newspaper stories.\nIn connection with your advertisement of the showing of Viola Dana in “Home Stuff,”\npublish the fact that you will conduct a contest for all single girls in your city which will\ngive them an opportunity to prove how expert they are in making any article of food or clothing that might be\nconsidered as coming under the designation of home stuff.\nAdvertise that these offerings will be judged by bachelors and that the judging will follow immediately after\neach showing of “Home Stuff” at your theatre. You should have about half a dozen bachelors to judge each\ncontest, and by advertising that the judges would be picked from the audience each time, their only qualification\nbeing that they must be bachelors, you would assure a big attendance of men.\nSo that you would have plenty of material each day for the bachelors to pass judgment upon, you should set\na time limit upon articles to be entered in the contest that day, requiring all contestants to have their offerings\nin, say, by noon, for the matinee performance, and by six o’clock for the evening showing.\nOn the final day of the showing you could reserve the contest for those who have been judged winners at the\nprevious performances and let the bachelor judges pass upon them. For the winners, you could offer prizes that\nyou think would be suitable.\nSuch a contest should furnish a good story for the newspapers each day, especially as there is no doubt that\nthe bachelors would be called upon to decide upon the virtues of all kinds of pies, cakes, jellies and other foods,\nin addition to needle work and articles of that sort.\n\n½-Col. Cut or\nMat No. 59-K\n\n[PAGE EIGHT]
s1229l16674	7	VIOLA DANA in “HOME STUFF”\nA ROMANCE EMBROIDERED ON GINGHAM\nThey’re Crammed to the Brim with Human Interest\n\nTHEIR OWN LIVES\nIN “HOME STUFF”\n\nViola Dana, Authors and Director of “Home Stuff” Know\nCountry Life First-hand\n\nTime will roll back for many residents of the big cities with their first glimpse of Viola Dana in “Home Stuff,” a piquant tale of laughs and tears, recently filmed as a special Metro production, and due for its local premiere ……… at the ……… Theatre.\n\nFor the picture is crowded with the all but forgotten home touches that will be recalled by every city dweller. Everything from the pet chicken that followed its mistress about the backyard, to the little opera house down on Main street, is in the production.\n\nIncidentally, there is no lack of authority for the small town features that find their way into the picture, for everybody connected with its filming,\n\neither is a product of the small town, or actually is living on a farm today. The versatile Viola herself spent most of her early girlhood in an upstate New York town.\n\nRecently she spent hours watching a setting hen whose forthcoming hatch will be seen in the picture. Setting hens is no new sport to the little star, however, who insists that her special work on her father’s farm was the management of the hennery.\n\nFrank Dazey and Agnes Johnston, the gifted screen writers, whose recent partnership—both domestic and professional—resulted in this story, now are living on a tiny ranch at Santa Monica, Cal. They are authority for the statement that the big situations of the production were worked out while they were dividing their time between the garden and chicken yard of their ranch by the ocean.\n\nAl J. Kelley, who has been promoted to the full rank of directorship for this production, had his early training in the town of Wallingford, Conn., where knowledge of small town ways is to be gleaned in places other than books.\n\nAlthough Mr. Kelley is but twenty-three years old, he has been entrusted with the most important of directorial duties since his coming to Metro four years ago. His varied experience as a newspaper writer, technician and assistant director, all have served to prepare him for the new duties with which he has been entrusted in the filming of this, the most ambitious special production in which Viola Dana ever has been seen.\n\nPLACE THEM\n\nDon’t expect your poster displays and newspaper ads to do everything. Help them out by placing in your town’s journals cuts of the star, surrounded by publicity stories. Many people skip ads. Many discredit the claims in them. You will corral a good many otherwise indifferent people by using such stories as these. Hence our advice to place them.\n\nVIOLA AND LIGHTS\nSTARTLE QUAKERS\n\nStir Settlement At Whittier, Calif., in the Blinding Glare From Portable Plant\n\nResidents of Whittier, the “Quaker City of the West,” were aroused during the small hours of the morning not so long ago by a flood of light that must have led them to believe they suddenly had been transported to the land of the midnight sun.\n\nFor the biggest portable electric light plant in the world—recently constructed for Metro’s West Coast studios—had been rolled into the quiet village for the shooting of night scenes about its little railroad station. And, since more than a score of powerful lights were brought into play, along with about twice the current necessary to light the entire town, a sensation was created even in this district where the making of movies is as familiar as orange growing.\n\nStrangely enough, the world’s biggest portable electric light plant was used for the first time to illuminate the antics of the world’s tiniest star. Viola Dana, starring in Metro’s production of “Home Stuff,” a Frank Dazey-Agnes Johnston story, was enabled to appear in a series of night scenes about the station such as never before have been possible except in studios and before stage settings only, because of the lack of powerful portable lights.\n\nThe new picture, to be seen ……… at the ……… Theatre, will offer numerous new and unusual features, not only because of the use of the gigantic electric plant, but because of a series of surprises planned by Albert Kelley, the youthful director of the production.\n\nViola Dana Creates New Dance, Wiggle-Wobble, for “Home Stuff”\n\nTwo-Col. Star\nCut or Mat No. 59-J\n\nPetite Viola Dana, the only film star to use a toe dance in pictures, has invented a new dance that promises to eclipse many of the popular jazz steps in general favor.\n\nWithin a few days, you probably will be asking your orchestra leader to play you a barn-yard “wiggle-wobble.” For that is the way Viola classifies the dance she devised for her special Metro production of “Home Stuff,” to be shown ……… at the ……… Theatre.\n\nThe new picture in which Miss Dana is being starred consists chiefly of farm and small town scenes—all of which were shot on a big farm and a typical small town near Los Angeles. Among the unusual incidents pictured is an old-fashioned barn dance. The story requires Miss Dana to depart from the accepted barn dance steps and interpolate others that will identify her with the stage.\n\nWhen she appeared in the gaily-decorated barn—the sort you may have done the Virginia reel in years ago—Viola surprised Director Albert Kelley by the new dance she staged, much to the delight of the barn-storming orchestra that was imported from a small town for the purposes of this picture only.\n\n“What is it?” demanded Kelley. “I’ve never seen it before.”\n\n“Neither have I,” answered Miss Dana. “I just made it up last night. Like it?”\n\nThe dance is a combination of the tremor of the shimmy, the burlesque of the old-fashioned cake-walk, and the grace of the waltz. Miss Dana is certain that her departure in dance invention will prove popular.\n\nIncidentally, the most varied cast of farm types ever seen on the screen participate in Miss Dana’s new production. Director Kelley, himself a product of a small town, refused to be satisfied with the usual screen subterfuges, but sent far and wide for the characters usually found at the barn dances of real life.\n\n“The art of make-up covers a multitude of defects, I realize,” said Mr. Kelley, “but some characters just can’t be made. The lip-stick and grease paint can’t produce everything. While they are essential in the actor’s make-up box, they can’t make ‘rube’ character when ‘rubes’ are needed. That’s why, when I read the ‘script for ‘Home Stuff,’ and knew a barn dance was called for in one of the scenes, I determined that I would search the city far and wide to obtain the real country types necessary for the situation.”\n\nAs a result, the most realistic gathering of farmer types was assembled for this phase of the production of “Home Stuff.”\n\nThe barn dance is but one of the many interesting phases of this tale of rural life, written by Agnes Johnston and Frank Dazey. Old-time husking-bees, bobbin’ for apples, Virginia reels to the tune of old fiddles—all have part in the country festival.\n\nRunaway Painfully Realistic\n\n“What we want is a genuine runaway team of farm horses,” said Director Al Kelley while filming Viola Dana’s latest Metro special, “Home Stuff,” at the west coast studios of the company in Hollywood, Cal. This is the picture the ……… Theatre will exhibit ………\n\nAnd the trouble is, that was what he got. A team of horses, attached to a hay wagon on which Viola Dana was perched, was induced to run away so effectively that they all but lost the star, director and cameraman. As it was, Viola, her director and John Arnold, her cameraman, are nursing bruises that are not ordinarily acquired in an even more serious bolt of horses.\n\nThe plot for “Home Stuff,” which is a Frank Dazey-Agnes Johnston story, calls for a realistic runaway. Tom Gallery, who is playing the leading male role in the picture, had been instructed to drop the reins on seeing Viola—a thing that his city breeding and ignorance of horses generally made very easy.\n\nAt the top and rear of the hay wagon was a little platform on which director and cameraman were working. The horses started to run in regulation style—offering plenty of excitement for picture purposes. Then a barking dog took up the chase and the horses bolted in real earnest. Swerving to one side of the road, they ran under an overhanging branch of a tree, resulting in several scratches to Miss Dana’s face, and an enforced jump by Director Kelley and Tom Gallery. The imperturbable Arnold continued to grind, however, with the result that the entire incident has been recorded for the film.\n\n[PAGE SEVEN]
s1229l16674	1	METRO announces\nVIOLA DANA\nin\nHOME STUFF\n©CIL 16674 From the original story by\nFRANK DAZEY and AGNES JOHNSTON\nDirected by\nALBERT F. KELLY\nJUN 14 1921\n1476 BROADWAY - NEW YORK CITY
s1229l16674	2	VIOLA DANA\nA ROMANCE EMBROIDERED ON GINGHAM\nin “HOME STUFF”\n\nTwo-Column Scene Cut or Mat\nNo. 59-C\n\nThe CAST\n\nMADGE JOY............VIOLA DANA\nRobert Deep............Tom Gallery\n“Ma” Deep............Josephine Crowell\n“Pa” Deep............Nelson McDowell\nSusan Deep............Priscilla Bonner\nMr. “Pat”............Robert Chandler\nMrs. “Pat”............Aileen Manning\nJim Sackett............Phillip Sleeman\n\nStory and Scenario by Frank Dazey\nand Agnes Johnston. Directed by\nAlbert J. Kelley. Photography\nby John Arnold. Art director,\nA. F. Mants.\n\nRemember the days of chores and\nchickens, of straw-rides beneath the\ngolden moons of youth? How fear-\nfully clean and starched and prim your\nbest girl looked at the church social?\nWell, “Home Stuff” is a story with\nsuch a setting; and more than that, it\nis one in which Viola Dana plays the\nchief part. It is a picture that’ll show\nyou whether or not you have a heart.\n\nScene from HOME STUFF,\nStarring VIOLA DANA.\nOne-Column Scene Cut or Mat\nNo. 59-A\n\nScene from HOME STUFF, Starring VIOLA DANA.\n\nThe Story Has Both Charm and Power\n\nAFTER barnstorming many tank towns the cheap road show in\nwhich Madge Joy stars comes to a standstill for lack of funds.\nNow, in the small town of Buckeye Junction, they are ready\nto disband unless some angel of mercy unexpectedly descends with financial\nbacking.\n\nAmong the interested spectators at Buckeye Junction are Susan Dupree,\na stagestruck girl who has run away from home, and an admirer of hers,\nJoseph Slack. Both go backstage after the performance. Slack tells the\nmanager he will back the show, if Susan is given the stellar position to replace\nMadge.\n\nMadge thus finds herself ousted and drives to a small nearby town to\ncatch the evening train to New York. But she misses it. Madge starts\ntowards the nearest farm. A huge mound of fresh-mown hay heaped on a\nrack proves too inviting, and the tired girl burrows her way in and falls asleep.\n\nTwo-Column\nScene Cut or\nMat No. 59-D\n\nRobert Deep, a handsome young farmer boy, drives two frisky horses to\nthe hay rack, and after starting off the load is startled to see a feminine face,\nfrom under the hay, peering at him. The dumbfounded boy drops his reins\nand the horses bolt forward. Madge is thrown unconscious to the ground and\ncarried by Rob to his home.\n\n“Ma” Deep is a regular mother, opening her heart to any sufferer. “Pa”\nDeep is austere. Both are excited when their son enters with his burden.\nTender care revives Madge, who senses, from the religious pictures hung on\nthe walls, that they would not relish knowing that they were harboring an\nactress. So she tells them she is a runaway orphan. The family decides to\nkeep her with them.\n\nMadge is given some clothes that belonged to a daughter, now “dead,”\nshe is told. At the mere mention of the daughter’s name the family becomes\ndowncast.\n\nOne day Madge is suddenly confronted by her old stage friends. The\nnew star had not met expectations and the show has disbanded. Madge is\nnot at all pleased but she greets the group and promises to get them work\non the farm if they will not divulge her former profession.\n\nONE moonlight night Rob confesses his love and proposes marriage to her.\nMadge, who likes him, tells him the truth about her past; he in turn\ntells her that he is a playwright with ambitions to go to New York to write.\n\nA church social is held at the Deep homestead. Rob urges Madge to\nelope with him, but she puts her answer off until later in the evening. Then\nMadge goes to Ma Deep and narrates the story of a girl, supposedly fictive,\nbut in reality her own life. The old lady senses this, takes Madge in her\narms and says it will make no difference.\n\nThen a knock is heard. In walks Susan Dupree, who is really Susan\nDeep. Susan tells that she decided to return after rebuffs and undesirable\nattentions have made life impossible to her.\n\nThe father is furious, but is calmed when Madge suddenly tells him that\nshe is an actress, and will take Rob away with her unless he is reconciled.\nHe consents and Madge fulfills her part by giving up Rob.\n\nMadge leaves and becomes a big Broadway stage sensation. One night,\nher manager enters her dressing room. A stranger, who has written a play\nfor her, he says, is outside waiting for an introduction. It is Rob himself,\nand Madge learns how his father had told the truth on his deathbed. Both\nsit down and read the play—and then they read each other’s eyes.\n\n[PAGE TWO]
s1229l16674	5	VIOLA DANA in “HOME STUFF”\nA ROMANCE EMBROIDERED ON GINGHAM\n\nAdvance Stories\nThe newspaper editors\nwant just such advance stories as appear below. Type\nthem, leaving plenty of margin on top of the page. They\nshould appear during the week preceding the showing.\nFor a smashing effect, try to\nhave a scene or star cut\naccompany the stories. Your\nadvertisements warrant this.\n\nVIOLA DANA PLAYS\nPART OF STAGE GIRL\n“Home Stuff,” Her Newest\nVehicle, Portrays Simple Life\nand Stage Struggles\n\nThe outstanding announcement of\nthe week, so far as the photoplay is\nconcerned, is the announcement of a\nnew Viola Dana picture. The vehicle\nis “Home Stuff,” a Metro special, which\nwill be shown at the …… Theatre on\n…… and will continue for ……. days as the feature attraction.\n\nThe screen boasts no more talented\npersonality than Miss Dana. For those\nwho have seen her, praise is superfluous; but for those yet to experience\ntheir first delights in seeing her perform, the advice to behold her in shadowland will certainly not be deemed\nsuperlative.\n\nIn “Home Stuff” Miss Dana has the\nstellar role of Madge Joy, leading lady\nof a cheap road show, which suddenly\ncomes to a standstill in a little town for\nwant of funds. Chance puts in her\nway both the refuge of a cozy farm,\nwhere she comes to live as one of the\nfamily, and the love of a young farmer.\nThen fate enters by bringing into the\npeaceful household Madge’s past in the\nform of old stage associates, and especially of Susan Deep, a stage-struck girl\nwho had left the very home Madge\nwas adopted into, and later returns penitent. The complications and thrills\nwhich are moulded into the picture\nwould take too long to tell.\n\nBoth the story and scenario were\nwritten by Frank Dazey and Agnes\nJohnston. Albert J. Kelley directed the\nproduction, and John Arnold worked on\nthe motion photography. The art direction is by A. F. Mantz.\n\nFor her supporting cast, Miss Dana\nhas the following: Tom Gallery, Josephine Crowell, Nelson McDowell, Priscilla Bonner, Robert Chandler, Aileen Manning and Phillip Sleeman.\n\nVIOLA DANA IN “HOME\nSTUFF” COMING HERE\n\nViola Dana, whose admirers on the\nscreen are legion, has the stellar role in\nthe Metro special production, “Home\nStuff,” which comes to the …… Theatre on …… for a run of …… days.\n\nViola Dana has the stellar role of\nMadge Joy, a leading lady of a cheap\nbarnstorming company, who finds a\nhaven in a quiet, simple farmstead, after\nbeing ousted from the company, and\nher place taken by an inexperienced\ngirl, whose admirer is willing to back\nthe impoverished show. Then the company of actors come to the farm, bringing with them the girl, a runaway from\nthe very home Madge has entered. The\nworking out of the plot is truly splendid.\n\nThis story by Frank Dazey and Agnes\nJohnston was directed by Albert J.\nKelley. John Arnold photographed and\nA. F. Mantz did the art work. The\nsupporting cast includes Tom Gallery,\nJosephine Crowell, Nelson McDowell,\nPriscilla Bonner, Robert Chandler,\nAileen Manning and Phillip Sleeman.\n\nReview Stories\nGive one of these review\nstories to your photoplay\neditors, for insertion on the\nday following the picture’s\nshowing. Such reviews have\na strong psychological effect\non the readers, many of\nwhom wait for a favorable\narticle before deciding to see\na picture. Submit it in\nplenty of time. A little\nreview story helps a lot.\n\n“HOME STUFF” HAS\nNO DULL MOMENTS\n\nViola Dana Stars with Distinction\nin Brilliant Picture of Stage\nand Farm\n\nIf theatregoers came to the …… Theatre yesterday to see “Home Stuff,”\nthe Metro special production which will\nbe the feature attraction for …… more days, expecting to get an exposition of home-brew, they were disappointed. But they were not disappointed in other respects. For “Home Stuff” is superlatively fine, with a story that has not one dull moment, and a cast whose acting has distinction and verve.\n\nViola Dana stars in this picture, and lives up to the reputation she has already earned for brilliant impersonation. We have seen her in different pictures, and while we liked them all, we are frank in saying that she is best in “Home Stuff.”\n\nAs Madge Joy, the leading actress\nwho finds herself stranded with an impecunious traveling show, Viola Dana is convincing. Madge plans to return to New York, but a series of circumstances brings her a home with farmers, who take her in as one of the family. The actress decides to forget the stage and settle down to a calm life. She loves a young farmer. Then enters a blustering company of actors, and a little runaway girl who turns out to be the daughter of the people who took Madge in. The denouement is packed with excitement.\n\nPraise is due Albert J. Kelley for the\ndirection of this Frank Dazey-Agnes\nJohnston picture, which was photographed by John Arnold, with art work\nby A. F. Mantz. Also to the supporting cast, which includes Tom Gallery,\nJosephine Crowell, Nelson McDowell,\nPriscilla Bonner, Robert Chandler,\nAileen Manning and Phillip Sleeman.\n\n“HOME STUFF” WITH\nVIOLA DANA PRAISED\n\nNo picture in a long while has had\nthe fortune to win such praise and\nenthusiasm as was accorded to “Home\nStuff,” the Metro special which was\nshown yesterday at the …… Theatre, where it began a run of …… days.\n\nViola Dana stars in this picture. Her\nacting has a wonder-compelling charm.\n“Home Stuff” is the story of Madge\nJoy, leading woman of a traveling\nshow, who abandons stage life to take\nup a quiet existence with a family of\nfarmers. Madge never mentions her\npast life to the austere couple, to whom\nthe stage is a sink of iniquity. Then in\ncomes her old associates, plus a young\ngirl who had run away from the very\nhome Madge has been adopted into.\nThe situation is worked out interestingly and engrossingly.\n\nAlbert J. Kelley directed this Frank\nDazey-Agnes Johnston picture. John\nArnold photographed, and A. F. Mantz\ndid the art work. The supporting cast\nincludes Tom Gallery, Josephine Crowell, Nelson McDowell, Priscilla Bonner,\nRobert Chandler, Aileen Manning and\nPhillip Sleeman.\n\nAccessories\n\nFOR YOUR LOBBY:\nTWO 22x28’s hand colored.\nSIX art-colored 11x14’s, and\nTEN sepia prints.\n\nFOR YOUR BILLING:\nONE smashing 24-sheet.\nONE arresting six-sheet.\nTWO compelling three-sheets.\nTWO splendid one-sheets. Window Card of half-sheet size.\n\nFOR YOUR NEWSPAPERS:\nA mine of publicity matter prepared by trained newspaper men.\nADVANCE and REVIEW stories for your dramatic editors. Prepared\nmatter for your program. Scene-Cuts in varieties of ONE three-column,\nTWO two-column, and TWO one-column cuts. Procurable in either mat or\nelectro form. STARCUTS in two-column and one-column sizes, obtainable\nin mat or electro. Ad Cuts for the newspapers, ONE four-column smash\nad, ONE three-column, ONE two-column, and a one-column ad. TEASER\nAdvertising Aids and Catch-Phrases.\n\nFOR GENERAL EXPLOITATION:\nA Herald, in two colors with synopsis of the story and scenes from the\nplay. Novelty Cutout Herald, also in colors.\nComplete exploitation campaign outlined by experts.\n\nMail Campaign\nMail This Postcard a Week Before Showing:\n\nDear M—:\nThere are all sorts of girls, and they can’t be classified simply as\ngood or bad. So with stage girls. In “Home Stuff,” the Metro special\nwhich comes to this theatre on …… for a run of …… days, the\nheroine, Madge Joy, is an actress who suddenly decides to let the flashy\nfootlights alone, and turn to the farm.\nBut something turns up to disturb the even tenor of her way. Come\nand see Viola Dana, the star who brims with personality and joy, interpret the part of Madge Joy. It is a treat.\nCourteously yours,\n\nAnd Two Days Before Showing, This Letter:\n\nDear M—:\nThis is merely another reminder that you can’t afford to miss “Home\nStuff,” which will be shown here on …… In our card we mentioned\nsomething of the principal character. Madge was going on smoothly,\nand her past seemed as faint as the ripples on water, when suddenly\nfate stepped in awkwardly as fate will do. Not tragically, but in the\nform of her past associates, and a young girl whom she had supplanted\nas daughter in the farmhouse, after the girl had supplanted Madge as\nleading lady of the road show.\nIt’s a truly fascinating plot, as unlike anything of its kind as you\ncan imagine. And you will agree that the acting of Viola Dana is a\nthing of ivy. Miss Dana is said to outdo herself in “Home Stuff.”\nCourteously yours,\n\n[PAGE FIVE]
s1229l16674	6	VIOLA DANA in “HOME STUFF”\nA ROMANCE EMBROIDERED ON GINGHAM\nPublicity Stories Editors Will Make Room For\n\nThe Little Movie Mirror Books\n\nStars of the screen are the objects of curiosity. People want to know about their personal, intimate lives, read of their chatter when off guard, look at their pictures.\n\nA chance for you to exploit this curiosity is offered in the Little Movie Mirror Books, three of which—on Viola Dana, Doraldina and Bert Lytell—are reproduced above. Each book contains sixteen pages of reading and illustrative matter on one star, written to give the movie fan an insight into the artist’s personality.\n\nThis novelty booklet can be used to advantage in different ways.\n1. Giving them away free to your patrons on the day the star’s picture is shown. 2. Arranging a tie-up with your newsdealer, thus deriving publicity for your theatre and exploiting the star. 3. You can obtain them direct through the Ross Publishing Co., of 1463 Broadway, New York City, at a wholesale price, or from the Metro Exchange, and either have ushers sell them, or place them in a booth in the lobby. They retail at ten cents.\n\nAMANDA HEN AMONG CAST OF “HOME STUFF”\n\nAmanda Hen, who was selected to enact an important role in Metro’s special production of “Home Stuff,” is one of the most attractive chickens in Hollywood.\n\nIn explanation of this broad statement, it may be said, however, that she is of the feathered and not the blonde variety, lives in a coop instead of a gilded cage, and arises rather than retires at sunrise.\n\nAmanda, who has shown rare ability in her work before the camera, owes not only her present position, but her very life to Viola Dana, who is starring in this picture, scheduled for ………. Theatre. For Miss Dana carefully selected the egg from which she was set, thus making it possible for Amanda to become a screen player instead of the basic ingredient of an omelette.\n\nOn the morning that Amanda cracked her shell and peeped out into the big Metro stage, that is the only world she ever has known, she was greeted by the fascinated Viola, who offered her her first meal of warm gruel. Because of the kindly ministrations of the star, Amanda has associated Viola so intimately with her three square meals a day that the two are inseparable.\n\nAnd since then, in gratitude, Amanda has provided her mistress with a fresh egg a day for nearly three weeks!\n\nFANS SEND VIOLA TOO MANY CHICKS\n\nTales of Amanda Hen Bring Flocks of Fowl For “Home Stuff”\n\nVIOLA DANA\nOne-Col. Star Cut or Mat No. 59-F\n\nToo many chickens, the cause of many a male star’s downfall, threatened trouble for Viola Dana, Metro’s petite player, while making “Home Stuff,” her newest picture.\n\nFor the fair Viola was surrounded by feathered fowls of every conceivable variety, age and color. And all were classified as pets, thus protecting them from the ordinary hazards of chick life—such as pot pies, roasting pans and stews.\n\nMiss Dana was engaged in playing the part of a little rural girl in Metro’s production of “Home Stuff,” a Frank Dazey-Agnes Johnston story. In this role, she was surrounded by many pets, such as ordinarily populate a farm. Chickens, pigs, cows, calves, horses, goats; in fact, all domestic animals made their appearance as screen players.\n\nEarly in the production of the picture, newspapers related how a tiny chick, christened Amanda Hen by Miss Dana, was to play in the film story. Since then, fans throughout the country have contributed the favorites of their brood to flit through the tale with the gifted Viola. Just how many fowls reached the Metro studio, even the company statistician is still unable to say.\n\n“I have been swamped with chickens from all over the country,” said the tiny Viola. “People read the story of my pet chicken, and have offered me various pets from their own ranches. Yesterday I received two of the cutest little bantams, with feathers that I would like to have on a hat. I have received ducks, with cunning little goslings, turkeys, and even pigeons. Now, this morning, the first thing that greets me is a big crate with a mother hen and her brood in it. I am going to keep them all, though, and maybe I can use them in another picture, as I wouldn’t think of eating them. They are all pets, for they follow me around like I had been their mistress for years.”\n\n“Home Stuff” is a tale of rural life, and most of the scenes are laid on a farm. The entire company spent several weeks on one of the oldest ranches in Southern California taking scenes that required the rural background.\n\nSupporting Miss Dana in “Home Stuff” are Tom Gallery, Josephine Crowell, Nelson McDowell, Priscilla Bonner, Robert Chandler, Aileen Manning and Philip Sleeman. The picture was directed by Albert Kelley, and photographed by John Arnold.\n\nMOVIE STAR GOES BACK TO FARM\n\nViola Dana’s Life Truly Rural While Appearing in “Home Stuff” Scenes\n\nViola Dana has gone back to the farm. For a whole month she spent all her time at the picturesque old Magnolia farm near Whittier, Calif.—the Quaker city of the West—working on “Home Stuff,” her newest Metro starring picture, written especially for her by Frank Dazey and Agnes Johnston. The production was directed by Albert J. Kelley. It will be seen ………. at the ………. Theatre.\n\nAfter scouring Southern California for a proper location for this rural story, the Magnolia farm finally was secured. It fitted the locale of “Home Stuff” as if designed for the purpose. The picturesque old farm house, barn and many outbuildings on the twenty-acre farm were built more than seventy years ago, but show no traces of decay. The farm has been occupied and kept up all the time. It was one of the first farms in the Whittier valley.\n\nDespite the fact that Miss Dana arose at 5:30 in the morning in order to arrive at the farm at 8:30, as it was forty miles from her home in Beverly Hills, the little star had the time of her life.\n\nThere were cows, chickens, horses, dogs, cats, turkeys, geese, hogs, and everything that goes to populate a real farm at the Magnolia place, and Miss Dana was right at home. Miss Dana, who was raised on a farm in New York state, was no novice at the life she had to live in the story of “Home Stuff.”\n\nA strong supporting cast supports Miss Dana for this production. Tom Gallery plays opposite the little star while Robert Chandler, Josephine Crowell, Priscilla Banner, Nelson McDowell and Philip Sleeman all have important parts in the supporting cast. John Arnold photographed “Home Stuff” and A. P. Mante was in charge of the art work. The entire company spent an entire month on the location securing the exteriors for this rural story.\n\nTOM GALLERY LEADING MAN\n\nTom Gallery, the stalwart Chicago boy who has taken the film world and one gifted star by storm during the past year, plays the leading male role in Viola Dana’s new Metro special production, “Home Stuff,” to be shown ………. at the ………. Theatre.\n\nThe handsome Tom will be seen in a part that he loves—that of a small town youth—in this story by Agnes Johnston and Frank Dazey. Al Kelley, who has been associated with Miss Dana for more than four years, is directing the production.\n\nTom Gallery’s meteoric rise in pictures is the subject of discussion even in this profession of quick changes, promotions and surprises. He made his picture debut in a tiny part slightly more than a year ago. He played “atmosphere” in several other productions, then was seen by Zasu Pitts, who immediately sought his services in the filming of “The Heart of Twenty.”\n\nVIOLA DANA\n\nTwo-Column Star Cut or Mat No. 59-G\n\n[PAGE SIX]
s1229l16674	12	VIOLA DANA\nA ROMANCE EMBROIDERED ON GINGHAM\nin “HOME STUFF”\n\nChores and Crullers\n• • •\nBillboard paper is valuable according to the\nmeasure to which it reflects the interest of\nthe picture it advertises. These one-sheets\nhit the mark in that. They suggest farm\nlife, fresh romance, the days of chores and\ncrullers.\n\nIn ordering paper,\nfollow the same\nprocedure as applies\nto cuts and mats:\nmention the size and\nnumber as listed in\nthis press book.\n\n1-Sheet No. 59-T\n\nSix-Sheet No. 59-Y\n\nPOSTERS\n\nof a size suitable to every use; and every one has a message\nthat will attract your public. Paper of the quality and\nartistry of this will explain why people build billboards.\n\nSocials and Straw-rides\n• • •\n“Home Stuff” is a story with such a setting\n— small-town, nearly rural stuff. Chickens\nand cows, kittens in a basket. Note how\nall the posters suggest the story. It’s\nappealing and fresh, the whole tone. It’s\nnot melodrama; it’s youthful romance.\nAnd that has the biggest appeal in the world.\n\nThe posters reproduced on this page are\nthe product of the Fine\nArts Lithographing Co.,\nof which Joseph H.\nTooker, is president.\n\n1-Sheet No. 59-V\n\nThree-Sheet\nNo. 59-W\n\nThe window card is not lithographed, but printed in three\ncolors: Persian orange, black and white. It’s a splendid\ndisplay magnet for merchants.\n\nWindow Card\n\nThree-Sheet\nNo. 59-X\n\nThe Stand is a Stunner\n\nMETRO\nVIOLA\nDANA\nIN HOME\nSTUFF\n\nTwenty-four Sheet No. 59-Z\n\n[PAGE TWELVE]
s1229l16674	10	VIOLA DANA in “HOME STUFF”\nA ROMANCE EMBROIDERED ON GINGHAM\n\nAds that Add\n\n▼ ▼\n\nto the number of tickets you sell for a picture are not\nscrambled together. They are planned and built carefully.\nHence we suggest urgently to exhibitors—unless they have\nsome particular circumstance in their town which lends\nitself to an exceptionally strong advertising appeal in their\nlocality—that they use the ads we have prepared for their\nservice. These, in preference to a hurried, makeshift\njumble of type the local printer may set up for you.\n\nAside from the points that you will, by using Metro ads, get\na striking display, well written copy and an assurance of\nclearness in printing, you’ll find our ads will save money.\nYou’ll save the cost of engraving a special picture, the cost\nof composition at the printer’s—and then you’ll have to\ndepend upon his perhaps limited selection of type and\naccept the unimpressive best he has.\n\nOur ads cost little, whether you buy them in mat or electro\nform. And they put the appeal of “Home Stuff” over with\na pleasing and interesting force.\n\nHe Had Never Seen Anyone Like Her\n\nThe girl who suddenly appeared in the hay\nwagon he was driving; the girl who startled\nhim so that he let the horses run away;\nthe girl who said she was a fugitive orphan;\nthe girl who was so different from the others\nin his village; the girl named Madge Joy;\nthe girl so winningly portrayed by\n\nVIOLA DANA in\nHOME STUFF\n\nStory by Frank Dasey and Agnes Johnston — Directed by Albert J. Kelley\n\nFour-Column Ad Cut or Mat No. 59-DD\n\nYouth is the Age of Romance\n\nWhen he sulks because she walked with Jim\nHaskins to get the mail at the postoffice.\nWhen she flares up and pouts because he\nsaid Nelly Wright’s hair was mighty pretty.\n\nSilly? Well, perhaps. But\nthey’re young, remember.\nAs young as Bob Deep; and\nMadge Joy, the girl played by\n\nVIOLA DANA\nin\nHOME STUFF\n\nIf you have a heart you’ll like it. If you haven’t, it’ll make you wish you had.\n\nStory by Frank Dasey and Agnes Johnston — Directed by Albert J. Kelley\n\nAbove: 3-Col. Ad Cut or Mat No. 59-CC\n\nRemember Those Days? A Bird in the Hand\n\nHow bright her eyes\nwere in the candle-light?\nHow fresh the flush of\nyouth in her cheeks?\nHow important every\nword of her chatter to\nyou?\n\nHow the paper said, “A\ngood time was had by\nall” at her party? And\nyou agreed with it.\n\nExcept the times when\nthat other fellow got a\nglance from her, and\nyou didn’t.\n\nHow much of the “colla-\ntion that was served”\nyou stared away?\n\nThey were good days;\nperhaps the best. Live\nthrough them again by\nseeing\n\nVIOLA DANA\nin\nHOME STUFF\n\nenacts with irresistible charm\nwhat happened to Madge\nthereafter.\n\nStory by Frank Dasey and Agnes\nJohnston\nDirected by Albert J. Kelley\n\nAt the Right: 1-Col. Ad Cut or Mat\nNo. 59-AA\nDirectly Above: 2-Col. Ad Cut or Mat\nNo. 59-BB\n\nIn reproducing the advertising cuts on this page, the\nexhibitor will understand that they are not actual size\nbut approximately half-size. Want of space makes this\nnecessary. The one-column ad cut you will receive on\norder is two inches wide, and the others are in the same\nproportion.\n\n[PAGE TEN]
s1229l16674	3	VIOLA DANA A ROMANCE EMBROIDERED ON GINGHAM in “HOME STUFF”\n\nBoost What the Title Implies\n\n▼ ▼ ▼\n\nThe Setting\n\nT HE name of the story in which Viola Dana appears says it all: “Home Stuff.” Let it be the keynote of all your advertising, your exploitation and your publicity. It is a title which tells in words simple enough to be understood by anyone the nature of Miss Dana’s latest photoplay.\n\nThe opportunities for stunts are practically limitless. Given a title such as “Home Stuff,” and you can readily see how it can be applied to anything connected with the home: pie-baking contests, barn-dances, tie-ups with merchants on household stuff, garden seeds; with real-estate men in home-building projects and partial payment schemes for selling houses.\n\nSo much for the exploitation, which is taken up in detail in this press book on pages eight and nine. As for the advertising, accent the fact that “Home Stuff” is a photodrama of charm and freshness and appeal. Hammer on the suggestion of chores and chickens, of the days when the family said grace over the red-checked tablecloth, of the days of harvesting and haying, of fishing through the ice—in a word, of village life in the days of youth, when the world seemed very sunshiny and simple and good. You can see its appeal. Every one of your patrons either has known such life, or read about it in books and magazines and so experienced it second-hand. To the city-dweller such life is so much poetry. He feels that, if it is not part of his own history, it should have been; and he will go to see the picture to visualize his dreams of how rural happiness might have been his share. To the country-bred a picture like “Home Stuff” doubtless will bring those pleasant reminiscences of his boyhood; it will be to him a breath of the new-mown hay the poets speak of.\n\nThe publicity that we have provided for you—it may be found on pages six and seven of this press book—has to do largely with the making of the picture. There occurred a legion of amusing and unusual incidents during the course of its production; and the best and most widely interesting of these have been taken and written for the columns of your local paper in the breeziest and clearest fashion by trained journalists who know what the public wants and how to provide it. Be sure that when you place advertising with your editor, you be assured of a fair display of reading matter in his news columns. It is coming to you. Be diplomatic but insistent.\n\nAnd always, in planning a publicity campaign, keep in mind events which you can bring about by exploitation in your town. If there is a pie-baking contest—just to take a random example—instituted in connection with the showing of “Home Stuff” at your theatre, make sure that news of it gets into the columns of your local journals. This, really, is the best publicity in the world, because it links local interest, by giving names of people in your community with the attraction in your theatre.\n\nThe Story\n\nA S for the nature of the plot of the story and its handling, it is sure-fire stuff. In these days of censorship, when many communities are making their own censorship laws, not to mention the national menace of restriction of the screen, there is no better policy, aside entirely from the intrinsic merit of such a photoplay as “Home Stuff,” than to show clean, heart-appealing and altogether impeccable pictures in your theatre. “Home Stuff” is the story of what happens to a little actress stranded in an out-of-the-way American village. It is a love story of unusual charm; what Anita Loos, in her recent book on photoplay writing, calls “fresh romance;” adding that it is the most valuable screen material to be had, as well as the scarcest. There can be no doubt, however, that in this latest picture written for Miss Dana the authors, Agnes Johnston and Frank Dazey, have struck the note of young love truly and sympathetically.\n\nThe Star\n\nA LL this in addition to the drawing-power of the star. It would be inadequate to say that “Home Stuff” was written to fit the capabilities of Viola Dana, for in the last year or so this young actress had displayed a versatility as pronounced as her charm. Her every picture has been a hit.\n\nRetracing the steps of her achievements on the screen during the last several months reveals a consistent series of successes. As the Italian girl, Sorrentina, in “Puppets of Fate,” she proved her emotional powers; as the spoiled, headstrong flapper in F. Scott Fitzgerald’s “The Offshore Pirate,” Miss Dana’s provocative charm, her irrepressible, bubbling vitality came to the fore in all their magnetism; in “Blackmail” and “A Chorus Girl’s Romance” she had roles quite different, yet none the less successful.\n\nIn brief, with these pictures fresh in the minds of your patrons, it is only natural that they should have the well founded opinion that a Viola Dana picture is an exceptionally good picture.\n\n“Home Stuff” is going to clinch that idea in their minds. The little star has a diversified appeal. If she had not so early in her career turned out to be an emotional actress, she undoubtedly could have made her name as famous as it is now in comedy parts. And in “Home Stuff” she has opportunity to do both sorts of work. Innumerable little touches in the farm scenes give a chance for comedy, and Miss Dana makes the most of every one. No less certain is it that the big dramatic scenes in “Home Stuff” are splendidly done.\n\nYou have one of the world’s most popular screen stars in a story that cannot but win your audience, when you show “Home Stuff.” Be sure that you make the most of it by an amount of advertising and exploitation commensurate with its possibilities.\n\nScene from HOME STUFF, Starring VIOLA DANA.\nOne-Column Scene Cut or Mat\nNo. 59-B\n\nThree-Column Scene Cut\nor Mat No. 59-E\n\nScene from HOME STUFF, Starring VIOLA DANA.\n\n[PAGE THREE]
s1229l16674	9	VIOLA DANA in “HOME STUFF”\nA ROMANCE EMBROIDERED ON GINGHAM\nCatch Phrases, Teaser Paragraphs and Additional Stunts\n\nCatch Phrases\nA story of love barnstorming.\n* * *\nWhen home stuff proves that it has a strong kick.\n* * *\nShows one way of keeping 'em down on the farm.\n* * *\nWhere an actress finds success concealed in a hayrack.\n* * *\nIn which the star finds the home stuff of the farm pays better\nthan the spotlight of the stage.\n* * *\nA bit of romance which starts on the farm but ends on\nBroadway.\n* * *\nJust a plain, old-fashioned home proves strangely attractive\nfor the members of the traveling show.\n* * *\nWhere an actress’ strange bargain nearly wrecks the happi-\nness of two lives.\n\nAttract Crowds With Band\nIn Poster-Decorated Auto\n\nThere is nothing like band music to get the attention of the public. When the\nmusic starts playing, it is human nature to turn and look, and those in offices will\ncome crowding to the window to see what it is all about.\n\nNext to a parade there is nothing to equal band music for getting the attention\nof the public. No matter when a band starts playing, it will always have a number\nof youngsters following after, and the added crowd serves as a further advertise-\nment to get the notice of others.\n\nMaking use of a band is a ballyhoo stunt whose value has been tested and\nproved by showmen who know how to get the public and get them to notice what\nthey have to offer in a way that will put it across.\n\nAdvertise “Home Stuff” with a band. For your particular locality, you can\nmake use of the musicians in a number of ways, all of which will prove good\nbusiness getters for your house.\n\nOne way that the exhibitor will find most effective in bringing the picture and\nhis theatre before the public is to have a large truck decorated especially for\n“Home Stuff.”\n\nWith the twenty-four-sheet and the smaller posters plaster the sides of the auto.\nSome extremely dramatic cut-outs can be arranged from the poster display which\nwill make good advertising for the sides\nof the truck. In addition to these, the\nshowman might find that some of the\nhand-colored lobby stills would also\nshow up well on the auto.\n\nTo bring out the feature of “Home\nStuff,” the band in the truck should\nfrequently play the old-fashioned tunes\nwhich were particularly popular among\nthe older folks, paying particular atten-\ntion to tunes like “Home Sweet Home.”\n\nIn addition to the instruments the\nexhibitor could get a novelty effect by\nhaving in the auto one of the small\norgans which are so often found in\nthe older homes, and the tunes on\nthis could work in with the offerings of\nthe musicians.\n\nBy having the truck drive slowly, it\nwill give people plenty of opportunity\nto see your display and at the same\ntime will allow your automobile band\nto cover a wide range of territory.\n\nAnd Don’t Forget\nthe value of such an obvious stunt as\nusing cuts of all sizes in your publicity\nand circularization matter.\n\nFURNITURE STORE AS\nAD FOR HOME STUFF\nCooperative Advertisement As\nGood Tie-up Stunt in Putting\nOver Feature\n\nWhen it comes to creating the home\natmosphere there is nothing quite so\npointed as furniture to bring it to the\nattention of the public. When people\nare figuring on a home they invariably\nstart to investigate the offerings of\nthe furniture stores and see what they\ncan get that will appeal to them.\n\nThe furniture stores or furniture dis-\nplays naturally suggest home stuff and\nbecause of this suggestiveness they form\nan excellent medium for the showman\nto arrange a tieup.\n\nA good cooperative advertising and\ndisplay campaign can be engineered by\nthe exhibitor with either a furniture\nstore or a department store, which is\nmaking a special feature of their furni-\nture exhibits.\n\nPrevious to the time for the showing\nof the picture, the showman could\narrange an advance advertising cam-\npaign in connection with the store which\nhe will use for his display. These\nadvertisements could be worded in a\nnumber of different ways, setting forth\nthe articles the store wishes to adver-\ntise, but always bringing out the fact\nthat they are home stuff. These adver-\ntisements could state:\n\nIF YOU ARE PLANNING TO\nMAKE YOUR HOME BEAUTI-\nFUL, VISIT THE FURNITURE\nDEPARTMENT OF JONES &\nCO., WHERE YOU WILL FIND\nEVERYTHING NECESSARY TO\nMAKE JUST AS HOMEY A\nHOME AS YOU WILL SEE\nVIOLA DANA PORTRAY IN\n“HOME STUFF” AT THE\n.................... THEATRE.\n\nOn your signs in the window display\nyou should have cards which will boost\nboth the furniture and the picture.\n\nThis furniture will brighten\nany home and\nVIOLA DANA\nin\n“HOME STUFF”\nWill brighten any home-\nlover. Now at the ..........\nTheatre\n\nVIOLA DANA\nOne-Column Star Cut or Mat No. 59-M\n\nContest For the Largest\nFamily Will Stir Interest\n\nLarge families are always of interest\nto the public at large, and even in\nthese days when the small family is con-\nsidered fashionable, there is keen curi-\nosity about those who have the multi-\ntudinous mouths at home to feed.\n\nIn showing “Home Stuff” the exhib-\nitor could exploit the large family idea\nfor some good advertising and also for\npublicity stories which should go over\nbig in the daily papers.\n\nAdvertise previous to your showing\nthat you will present free tickets to\nthe father of the largest family for his\nchildren at a performance of “Home\nStuff.” In your advertisement, of\ncourse, you should state that the father\nwould be required to present records\nso as to verify his claim.\n\nBy having the contest opened several\ndays before the showing, it would allow\nyou to receive the requests in time so\nthat you could award the winner the\nseats for a designated showing of\n“Home Stuff.” It is probable that the\nnewspapers would be interested to get\na picture of the family claiming to\nbe the largest in the city or town where\nthe picture is being shown.\n\nTeaser Paragraphs\n\nStranded in a Strange Little Town, the star of the barnstorming company,\nfriendless and broke, turns to the nearest farm house for shelter and finds that all\nthe adventures and thrills are not confined to the big cities. What happens to the\nlittle barnstormer is entertainingly pictured by Viola Dana in “Home Stuff,” a Metro\npicture, showing at the ....................... Theatre.\n\nHis Son Was in Love With an Actress and the austere father furiously\nthreatened all sorts of vengeance until his own daughter was lured to the white lights\nand then in his despair he made a strange bargain which vitally affected his entire\nfamily. Viola Dana in “Home Stuff,” a Metro picture, at the ..................... Theatre,\nshows how that bargain came to be made and what trouble it caused.\n\nShe Told Him of Her Past When He Proposed, but the country lad was not to be put off and urged\nher to elope with him. In her stage experience the show girl had discarded many loves but this one was\ndifferent and the homeless girl after making her decision found she had started something which she was\npowerless to stop. Viola Dana in “Home tuff,” a Metro picture, now being shown at the .....................\nTheatre, vividly portrays the stormy course of that love.\n\nViola\nDana\n¾-Col. Cut or\nMat No. 59-N\n\n[PAGE NINE]
s1229l16674	11	Not What We Say —\n\nYou exhibitors may become skeptical of our insistence over and over upon the supreme merit of “The Four Horsemen of the Apocalypse.” Hence we’re reprinting on this page excerpts from a full-page review in LIFE, issue of March 24, 1921, in order that you may judge in advance of the picture’s worth not by what we say but by entirely independent criticism:\n\n“‘The Four Horsemen of the Apocalypse’ is a living, breathing answer to those who still refuse to take motion pictures seriously. Its production lifts the silent drama to an artistic plane it has never touched before. . . .\n\n“. . . ‘The Four Horsemen of the Apocalypse’ will be hailed as a great dramatic achievement . . .\n\n“. . . Comparisons necessarily are odious, but we cannot help looking back over the brief history of the cinema, and trying to find something that can be compared with ‘The Four Horsemen of the Apocalypse.’ The films which first come to mind are ‘The Birth of a Nation’, ‘Intolerance’, ‘Hearts of the World’, and ‘Joan the Woman’; but the grandiose posturings of David Wark Griffith and Cecil B. DeMille appear pale and artificial in the light of this new production . . . . Nor does the legitimate stage itself come out entirely unscathed in the test of comparison, for this mere movie easily surpasses the noisy claptrap which passes off as art in the box office of the Belasco Theatre. . .\n\n“Robert E. Sherwood.”\n\nRemember this is not what we say. Mr. Sherwood, screen critic of LIFE, has gone to heights of praise even our own inspired publicity department could not attain.\n\nMetro\n\n[PAGE ELEVEN]
s1229l16359	2	Form 1343 6-19 500\n\nTitle of Motion Picture\n\nThe Sky Ranger\n\nProduced and Manufactured by\nPATHE EXCHANGE, Inc.\nNEW YORK, N. Y.\n\nCopyrighted
s1229l16359	3	APR -6 1921\nAPR -6 1921\n© CIL 16359\nTHE SKY RANGER\nEpisode #3.\n"In Hostile Hands"\n\nGeorge is clever enough to escape Dr. Santro and return\nJune, safe, to her father. His heroic acti ons alter Prof. Elliott's\nattitude and convince him that George is a friend, and not an enemy.\nJune also, forgives the young man for his audacity.\n\nSantro's second attempt to kidnap June succeeds. He also\nkidnaps George, and after hours of maddening whirling through\nspace, George and June finds themselves, alone, on a wind-swept\nplain in an obscure little country in Asia.\n\nIn the darkened courtyard of an inn in a nearby town a pilgrim\nis murdered and robbed of his bag of silver. June's scream when\nshe stumbles over the body awakes the inmates of the inn. June and\nGeorge are soon surrounded by a howling, meaining mob, who grab\nthem and hurry them through the dark streets to the temple of jus-\ntice for traila\n\nSantro, watching from a doorway, is satisfied with his night's\nwork, but Tharen, whose sympathies are with George, becomes frantic\nwhen Santro tells her that the best that can happen is death--the\nworst is a life sentence to the chest.
s1229l16359	4	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l16359	1	L16,359
s1229m00140	3	APR - 6 1914 © CLM 140 ✓\n\nA synchronism of Motion Picture and Phonographs — This\nsketch being one of Harry Lauder, the Scottish comedian, sing-\ning — "SHE'S MA DAISY".
s1229m00140	4	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229m00140	1	M 140
s1229m00140	2	Title of Motion Picture\n\nHARRY LAUDER SINGING "SHE'S MA DAISY".\n\nProduced and Manufactured by\nTHE SELIG POLYSCOPE CO., INC.\nCHICAGO, ILL.\n\nCopyrighted\n1914
s1229l11259	26	-21-\n\nScene -118  INTERIOR.  CLOSE-UP - of MIRIAM - IN #114 - tortured\nwith doubt, in an agony of soul.\n\nScene -119  INTERIOR.  CLOSE-UP - of CALVERT - IN #114 - continuing\nhis story.\nFADE\n\nScene -120  EXTERIOR.  FADE IN -- Section of Western station platform,\nshowing train.  BRETT and MRS. CALVERT go aboard.\n"BULLION BURKE", roughly dressed, and two companions\nare on the platform, and it is seen that they are\ndiscussing the runaways.\n\nScene -121  EXTERIOR.  CLOSE-UP - of BURKE - IN #120 - wondering what\nis "being pulled off."\n\nScene -122  EXTERIOR.  (BACK INTO #120)  Train pulls out.  BURKE and\ncompanions are on the platform and as BRETT airily\nwaves goodbye, they respond.\nFADE\n\nFade in.\n\nScene -123  INTERIOR.  CLOSE-UP - of CALVERT - IN #114 - he concludes\nhis story.\n\nScene -124  INTERIOR.  CLOSE-UP - of MIRIAM - IN #114 - showing her\nmixed emotions.  Doubt, resentment, love for a\nman from whom she must not be separated -- that\nwas her greatest fear about this time.\n\nScene -125  INTERIOR.  (BACK INTO FULL SCENE #114)  LEE, realizing\nwhat a worthless scamp BRETT is, is quickened into\naction.  Leaping to his feet, points and says that\nBRETT is in the other room.  The SHADOW MAN eager\nfor his prey, springs forward, but MIRIAM is\nquicker than he and bars his way with her arms\nacross the door.  LEE savagely hurls MIRIAM away\nfrom the door and the SHADOW MAN bursts in.
s1229l11259	13	-8-\n\nScene -28/A EXTERIOR. RAILWAY STATION AT MILLBOROUGH. Train pulls in and BRETT alights. Old LEE is talking to the station agent concerning a shipment of some goods, when BRETT, cigarette in mouth, and smartly dressed in comparison with the other characters in the scene, comes to the station agent, turns over baggage checks, and asks LEE about hotel accommodations in the town. LEE briefly tells him, pointing off and BRETT jauntily goes. LEE makes uncomplimentary remark concerning the city man, to which the station agent heartily agrees.\n\nSUB-TITLE: AN ADVENTURE INTO HONEST TOIL.\n\nScene -29 INTERIOR. NOON. BOOKKEEPING DEPARTMENT - of factory at Millborough. Showing BRETT at desk, looking up at clock, and just closing the register. He yawns, dons his hat and coat, lights a cigarette, and exits, with several of the other clerks.\n\nScene -30 EXTERIOR. STREET CROSSING IN MILLBOROUGH. MIRIAM comes on in foreground and when she reaches the curb the little boy darts away in front of her just as an automobile comes along. She shrieks when it seems that the boy must surely be run down; but, at this juncture BRETT comes - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
s1229l11259	39	-34-\n\nScene -188 INTERIOR. (BACK INTO #186) BURKE'S suite. BURKE comes\ndown and sits. Knits brows and smokes meditatively,\nopening and closing his fist. Thinks. Smile of\nintelligence finally breaks on his face.\nFADE OUT\n\nScene -189 INTERIOR. (CUT BACK TO #175) BURKE and BRETT face to face.\nBURKE trying to recall where he had seen BRETT\nbefore.\n\nScene -190 INTERIOR. CLOSE-UP - of BURKE - AS IN #188 - strikes the\ntable and says - "I've got it!" He has recalled\nhis first meeting with BRETT.\nFADE OUT\n\nScene -191 EXTERIOR. (SAME AS #120) CUT BACK -- BRETT getting on\ntrain and waving goodbye. BURKE and companions\non platform. Train goes. BURKE starts off when\nCALVERT and cowboys ride up.\nFADE\n\nScene -192 INTERIOR. (BACK INTO #188) CLOSE-UP - of BURKE -\ndebating what he will do, now that he has placed\nthe rascally husband of MIRIAM. BURKE finally\ndecides what to do. Takes paper and writes.\nLooks at message and smiles grimly.\n\nScene -193 THE TELEGRAM:\n\n"ED. CALVERT\nGREEN FORKS RANCH\nCOLT, ARIZONA.\n\nTHE MAN YOU WANT IS TO BE FOUND ANY NIGHT\nAMID THE BRIGHT LIGHTS OF BROADWAY. CLEAR\nTRAIL. EASY ROUND UP.\n\nA FRIEND."
s1229l11259	45	-40-\n\nof the discreditable business to him, and, in tears\nasks his forgiveness.\n\n"There, you know it all", she says. He tells her he\nhas known it from the very start and had seen that she\nwas more the dupe than he would ever be. He begs\nher to leave the gang. Come, break away! If not\nhome, then the world was large enough for a new home\nand a new beginning.\n\nSpoken title; "But I am his wife!"\n\n(BACK INTO SCENE) MIRIAM, though shaken and\nirresolute, is recalled to her sense of duty.\nAnd, reminds BURKE that she is another man's\nwife. BURKE starts to reply as though he were\nabout to tell her the information HAZEL had given\nhim --- that MIRIAM, vaunting herself on her con-\nsistent wifehood, is no wife at all.\n\nSpoken title; "But what if you are not?"\n\n(BACK INTO SCENE) BURKE asks the question simply,\nseriously and kindly. He hesitates to wound the\nfeelings of the woman whom he already has come to\nlove, but he feels that she is on the verge of a\nclimax where she must know --- where BRETT'S miser-\nable deception and perfidy must be revealed. And,\nthe big man's heart is full of pity for the little\nfair-haired dupe. MIRIAM starts as he asks the\nquestion. There was something in his voice and\nmanner which, for the first time in her married life,\nbrought to her a troublous disquiet.\n\ncene -224 INTERIOR. CLOSE-UP - of MIRIAM - IN #223 - "What if I am\nnot a wife?" MIRIAM is repeating to herself,\nseeking in her mind an answer and feeling that\nBURKE must have some sufficient reason for asking\nthe question. Then comes to her mind, with the\nsignificance that never before attached to them,\nthe actions of HAZEL and the STONES toward her ---\nBRETT'S own attitude of late, and, now as a climax\nto all of these vague and unformed things comes\nthe scene which she witnessed in the garden. The\nlittle dupe begins to awaken.
s1229l11259	42	-57-\n\nScene -204 EXTERIOR. PORCH OF BRETT VILLA. Set with dining tables. Seated are BRETT with MIRIAM on one side and HAZEL on the other. Next to MIRIAM, who wears the serpent crown, is BURKE. MR. and MRS. STONE and couples ad lib. Merry with wine. Rapid fire talk, and toasts. BRETT attentive to HAZEL. MIRIAM makes obviously strained attempt to be jovial. BURKE politely attentive, but cold sober.\n\nScene -205/206 EXTERIOR. CLOSE-UP - of BRETT and HAZEL at table - IN #204 - BRETT has her touch his glass with her lips and then, leering at her, drinks.\n\nScene -207 EXTERIOR. CLOSE-UP - of MIRIAM and BURKE at table - IN #204 - She notes BRETT'S action. Smouldering indignation, but turns smilingly to answer remark of BURKE'S.\n\nScene -208 EXTERIOR. PORCH. (BACK INTO #204) While the others are busy chatting, BRETT and HAZEL rise and go from porch out. MIRIAM jealously notes it. Fable\n\nScene -209 EXTERIOR. GARDEN SEAT. BRETT and HAZEL. He kisses her, then lights a cigarette. They chat.\n\nScene -210 EXTERIOR. (BACK INTO #208) PORCH. MIRIAM wonders where BRETT and HAZEL have gone. She rises and is arranging her mantilla about her shoulders. BURKE helps her, almost missing her in the operation, but she gently backs out of it. They go.\n\nScene -211 EXTERIOR. SPOT IN GARDEN. BURKE and MIRIAM. She halts suddenly and grips his arm in surprise. He follows her glance.\n\nScene -212 EXTERIOR. (BACK INTO #204) GARDEN SEAT. BRETT and HAZEL are locked in each other's arms.
s1229l11259	44	-59-\n\nScene -220  INTERIOR.  HALL OF VILLA.  (SAME AS #216)  MR. and MRS. STONE are on with BRETT.  They are telling him of MIRIAM'S retirement to her room and of BURKE'S following her.  BRETT expresses gratification and glee that MIRIAM, as he thinks, is going through with the job.  Both STONE and his wife are congratulating him on the success of the scheme.  They all hope to make a clean-up when MIRIAM lands the millionaire.\n\nScene -221  INTERIOR.  (BACK INTO #219)  MIRIAM is surprised upon seeing BURKE enter the room.  He stands and sympathizes with her.  She answers in monosyllables is nervous and distracted.  BURKE sits in a chair in front of her.  He asks her why she does not give up the life that she is living and says that she, besides being deceived, is being used as a tool for the benefit of others, and that when she has served the purpose they will throw her aside.  MIRIAM begins to protest, but the strong man stops her with a gesture.  MIRIAM asks what he would advise her to do.  He says -- "Go back home!"  "Home!" she repeats the word.  FADE OUT\n\nScene -222  EXTERIOR.  FADE IN --- Flash of #155 --- DOOR OF LEE HOME --- with MIRIAM weeping against it.  FADE OUT\n\nScene -223  INTERIOR.  (BACK INTO #221)  MIRIAM shakes her head in a sad negative, realizing that the door is forever shut against her, and tells BURKE that is impossible.\n\nSUB-TITLE:  MIRIAM CONFESSES THE UNWORTHY SCHEME.\n\n(BACK INTO SCENE)  MIRIAM is awakened to a bitter shame by the honest attitude of BURKE toward her --- shame that he has acted squarely in his admiration for her and his sincere concern for her welfare.  And, despite herself, she has grown to like him --- like him more than she herself realizes.  Here is a man strong as rock and yet tender, with sympathy, whom, she, swept into a sea of uncertainty and doubt, feels he is a real safe haven.  She resents the part she was to play in the miserable scheme to "land" him and flushed with shame, she confesses the whole
s1229l11259	50	-45-\n\nScene -243 INTERIOR. (BACK INTO #241) BARBARA solemnly gives her\nassent and LEE reads another verse.\n\nScene -244 INTERIOR. CLOSE-UP - of 13th verse.\n\n13- And Moses cried unto the Lord, saying,\n"Heal her now, O God, I beseech thee!"\n\nScene -245 INTERIOR. (BACK INTO #245) BARBARA assents and says\nthat the constant prayer of LEE should be for\nthe healing, the restoring of MIRIAM. LEE says\nhis prayers have so been --- night and day ---\nand he knows God will answer, just as he answered\nMoses. Here, here in The Book is the promise.\n\nScene -246 INTERIOR. CLOSE-UP - of 14th verse, finger underscoring\nthe words marked in the copy.\n\n14- And the Lord said unto Moses, "If her\nfather had but spit in her face, should\nshe be not ashamed seven days? Let her\nbe shut out from the camp seven days, and\nafter that let her be received in again."\n\nScene -247 INTERIOR. CLOSE-UP - of LEE - IN #243 - He is devotedly\nsaying - "God grant this be so for MIRIAM ---\nmy MIRIAM!" Tears are in his eyes.\n\nScene -248 INTERIOR. CLOSE-UP - of BARBARA - IN #245 - Her face\nexpresses hope for the return of the lost one\nand her lips move in supplication.
s1229l11259	16	-11-\n\nScene -47 EXTERIOR. LEE'S OFFICE. MILLBOROUGH. Sign reads ---\n"ALDEN LEE, ATTORNEY AT LAW."\n\nLEE comes out, locks the door, passes the time of evening with a passer-by and goes.\n\nScene -48 EXTERIOR. LEE HOME. NIGHTFALL. KIDS down at the gate looking for MIRIAM. It is dinner time and father will soon be home. The girl says that dinner must be ready when dad comes. The boy says how can it when MIRIAM is not on hand. The girl smiles her little chest and says ---"I'll do it!" The boy scoffs at first, but finally heartily agrees and says he will help, too. They scamper back to the house.\n\nScene -48/A EXTERIOR. STREET. Flash of LEE on way home.\n\nScene -49 INTERIOR. LEE DINING ROOM. Typical, old-fashioned, New England room. Heavy mahogany sideboard. Old silver, candlesticks, etc. The girl kiddie has fastened one of MIRIAM'S aprons about her and put on a dusting cap, which, of course, is ridiculously large for her. The dishes are on the table and she calls off into the kitchen for the boy. He staggars in with a boiled ham on a platter, but stumbles with it. She picks it up and brushes it with a feather duster, scolding the boy for his clumsiness. He begins to sass her. She stamps her feet, declaring that she is the boss now. She makes him stand erect and salute her. She bows to it and then orders him back into the kitchen.\n\nScene -50 INTERIOR. KITCHEN OF LEE HOME. BOY entering from the dining room. Goes to ice-box which is open, and looks in doubtfully. Glances up at closet. Smiles. Takes chair and reaching up to shelf, takes pie. Gets down and starts toward dining room, but pauses, looking longingly at the pie.\n\nScene -51 INTERIOR. CLOSE-UP - of the BOY - IN #50 - with pie in hand. Looks at it. The temptation is powerful. Starts to go with it, but stops. Looks at pie and at last yields. Grabs a handful of it and begins to eat with a blissful smile on his face.
s1229l11259	24	-19-\n\nScene -105 INTERIOR. CLOSE-UP - of MIRIAM - IN #102 - expressing\nhappiness and admiration for her hero, thinking\nthat he had been told that her father wanted to\nsee him, and thus came willingly to her house.\n\nScene -106 INTERIOR. (BACK INTO FULL SCENE #102) SITTING ROOM.\nBRETT feels as though MIRIAM has led him into a\ntrap, and nervously shakes hands with her father\nwhen introduced by MIRIAM. The old man asks how\nlong the friendship has been going on and welcomes\nBRETT with stately formality. BRETT has regained\nhis poise and is maintaining a conversation, but it\nis seen that LEE does not regard him with entire\napproval. MIRIAM, on the other hand, is elated\nand overjoyed that this man has come to their house.\nMeantime, the little GIRL has come in and shakes\nhands with BRETT. LEE sends the KIDS off to bed\nand he, BRETT and MIRIAM sit.\n\nScene -107 EXTERIOR. DARKENED PORCH OF LEE HOME. SHADOW MAN peering\ninto lattice door window, just the profile of his\nface outlined by high light, or half suggested.\nEntire figure may be lost if only the emphasis is\non the head, with its characteristic Stetson hat.\n\nScene -108 INTERIOR. (BACK INTO #106) SITTING ROOM. LEE, BRETT and\nMIRIAM discovered. Old man is anxiously questioning BRETT.\nBRETT is "stalling" and anxious to\nmake his get-away.\n\nScene -109 EXTERIOR. (CUT BACK TO #107) CALVERT at window on porch.\n\nScene -110 INTERIOR. (BACK INTO #108) BRETT looks toward window and\nsees the silhouette of the SHADOW MAN'S HEAD. He\nstarts in terror.\n\nScene -111 EXTERIOR. (CUT BACK TO #109) CALVERT is seen rapping\non the window.
s1229l11259	21	-16-\n\nScene -85 INTERIOR. (BACK INTO #85) CLOSE-UP - of MIRIAM'S girl\nfriend at telephone. Girl reluctantly promises\nto square MIRIAM. Hangs up telephone and then\nlooks at it puzzled and doubtful.\n\nScene -86 INTERIOR. (BACK INTO #84) CLOSE-UP - of MIRIAM - at\ntelephone. She hangs up with an expression of\nthankfulness and relief.\n\nSUB-TITLE: MANY CLANDESTINE MEETINGS\nGREW OUT OF MIRIAM'S FIRST\nFALSEHOOD.\n\nScene -87 EXTERIOR. ROAD IN MILLBOROUGH. BRETT in scene, smoking,\nlooks at watch expecting MIRIAM.\n\nScene -88 INTERIOR. SITTING ROOM IN LEE HOME. (SAME AS #2) LEE\nand children at table. The KIDS have their school\nbooks and are studying the lessons for the morrow.\nBoth of them are asking--- the Old Man a question,\nas MIRIAM exits. The Old Man watches her sus-\npiciously. The children repeat the question to\nLEE and he sternly commands them to be silent.\nAll of his first suspicion of MIRIAM is coming\nback to him and he determines to find out just\nwhat is happening.\n\nScene -89 INTERIOR. MIRIAM'S BEDROOM. (SAME AS #64) MIRIAM\nnervously gets her hat and coat and exits.\n\nScene -90 INTERIOR. HALLWAY, from entrance to the house. MIRIAM is\nseen coming down stairs.\n\nScene -91 INTERIOR. SITTING ROOM. (CUT BACK TO #88) LEE rises and\ngoes to door leading into hallway, and looks.
s1229l11259	19	-14-\n\nScene -71  INTERIOR.  (BACK INTO #64)  MIRIAM'S BEDROOM.  DARK SCENE.  LEE opens the door, candle in hand.  Goes to bed, and, shading candle throws light on bed.  MIRIAM is asleep.\n\nScene -72  INTERIOR.  CLOSE-UP - of MIRIAM - IN #71 - with light of candle on her face.  She is apparently asleep, though her eyelids are seen to quiver.\n\nScene -73  INTERIOR.  (BACK INTO #71)  MIRIAM'S BEDROOM.  LEE regards the sleeping girl for an instant, seems about to rouse her, but changes his mind.  Turns and the candle light on his face brings out sharply, in high light and deep shadow, the mental turmoil from which he is suffering.  Oh, but he will know all in the morning.  He exits.\n\nSUB-TITLE:  MIRIAM AROSE EARLIER THAN USUAL\nTHE NEXT MORNING.\n\nScene -74  INTERIOR.  LEE SITTING ROOM.  (SAME AS #2)  MIRIAM discovered taking clock and winds it.\n\nScene -75  INTERIOR.  CLOSE-UP - of clock being set - IN #74 - .  It marks 9.30, but MIRIAM turns the hands to indicate six o'clock.\n\nScene -76  INTERIOR.  (BACK INTO #74)  MIRIAM has just replaced the clock when LEE enters.  He stands facing her again grim and silent, and under his accusing gaze she is nervous and unstrung though she makes a desperate effort to be calm.  He asks her for an explanation and she tells her first lie.\n\nSUB-TITLE:  WHEN YOU TELL YOUR FIRST LIE\nYOU HAVE TO KEEP ON LYING.\n\n(BACK INTO SCENE)  MIRIAM tells him that she visited the house of a friend and was detained there until nearly nine o'clock.  FADE
s1229l11259	11	-6-\n\nLEE has opened and with a mother's loving vision,\nbegins to speak of the future of her children. LEE\nis attentive and it is shown that he is deeply\ninterested in the things that she is picturing to\nhim.\nFADE OUT\n\nScene -23 INTERIOR. FADE IN --- (BACK INTO #21) --- At the recollection\nof his dead wife, LEE breaks down and sobs like a\nchild. Hearing MIRIAM'S knock on the door, he quickly\ndries his eyes, and once more becomes the Man of\nGranite. MIRIAM enters and realizes what has taken\nplace. Her face grows sad for a moment in sympathy\nfor the old man, but her mood immediately changes and\nshe appears bright and happy. She points to herself\nas one who is determined to bring him joy and happiness--\nto give something of the interest and love to the home\nby which her mother's death has deprived him --- one\nwho would devote herself to the care of her little\nsister and brother --- one who would be both daughter\nand mother. She has knelt beside his chair during\nher speech. The old man does not answer in words,\nbut lays his hand upon her head and then arises and\nwalks gloomily from the room. MIRIAM arises, looks\nafter him and smiles pathetically.\nFADE\n\nScene -24/25 INTERIOR. (SAME AS #6) MR. and MRS. STONE and HAZEL dis-\ncovered. They are discussing the absence of BRETT.\nHAZEL in a rage, saying that she knew he intended to\nget out and she will get square. They hear the bell\nringing and STONE goes to the door. Opens it.\n\nScene -26 INTERIOR. CLOSE-UP - of DOOR of Apartment - SHADOW MAN,\ngrim and menacing, standing in entrance. He speaks.\n\nScene -27 INTERIOR. DOOR OF STONE'S APARTMENT from the hallway without.\nThe SHADOW MAN with Stetson hat and frock coat is\nstanding in it and over his shoulder is seen the face\nof STONE. STONE is shaking his head in the negative,\nsaying that BRETT is not there. SHADOW MAN forces\nhis way in.
s1229l11259	18	-15-\n\nScene -62 INTERIOR. (BACK INTO #60) SITTING ROOM. LEE is asleep\nin his chair. MIRIAM is seen at the entrance at\nright looking in at him. She looks at clock\nwith a start of surprise.\n\nScene -65 INTERIOR. CLOSE-UP - of CLOCK - IN #58/60 - marking 9.30.\n\nScene -65/A INTERIOR. (BACK INTO #62) SITTING ROOM. MIRIAM leaves\nentrance, as LEE stirs uneasily in the chair.\nFADE\n\nScene -64 INTERIOR. MIRIAM'S BEDROOM. She stealthily enters.\nTakes her small clock from the dresser and looks\nat it.\n\nScene -65 INTERIOR. CLOSE-UP - of CLOCK - in MIRIAM'S HAND - IN #64 -\nThe hands indicate one o'clock.\n\nScene -66 INTERIOR. CLOSE-UP - of MIRIAM holding clock. Her haunted\nlook gives place to an expression of relief. She\nsees a chance for her first successful deception through the clock that has stopped\nat 9.30 in the sitting room.\n\nScene -67 INTERIOR. (BACK INTO #64) MIRIAM'S BEDROOM. She replaces\nclock and begins hastily to disrobe.\nFADE\n\nScene -68 INTERIOR. (BACK INTO #62) LEE'S SITTING ROOM. HE wakes,\narises, and looks at clock.\n\nScene -69 INTERIOR. (Flash back to #65) Clock marking 9.30.\n\nScene -70 INTERIOR. (BACK INTO #68) LEE wonders whether MIRIAM has\ncome in while he was asleep and exits.
s1229l11259	27	-22-\n\nScene -126 INTERIOR. (BACK INTO #113) SHADOW MAN plunges in, followed by MIRIAM. He notes the open window and leaps out. MIRIAM sees note on table, and picks it up, just as her father enters. She holds it behind her back. He sees it and demands to know what it is. He holds out his hand and demands that she give it to him. This is the climax where the girl develops into the woman. She firmly refuses to give up the note, and as LEE denounces her unworthy lover, she suddenly bursts into a passionate upholding of him. YES -- she loves him, despite of all that has been revealed of his past. YES -- the note asks her to go away with him. She will do it, despite father and all the home ties. Against this torrent of emotion, old LEE is silent and suddenly his mood changes. He tries to persuade her to stay. She is his daughter after all -- his own flesh and blood -- the girl of which he is proud -- the daughter and little mother of his home. And, then her mother -- had she forgotten? And, as he goes back and recalls the past she is momentarily held by the picture. Fade\n\nScene -127 INTERIOR. LEE'S BEDROOM. (SAME AS #21) MRS. LEE on her death-bed. Father standing grimly by and the two KIDS looking on with wondering eyes, silent in the impressiveness of the scene. MIRIAM is bending over her mother and the mother is telling her to take care of the father and the children when she is gone, as a dutiful daughter should do. MIRIAM indicates that she will do so and her father reverently places his hand upon her head. FADE OUT\n\nScene -128 INTERIOR. FADE IN -- (BACK INTO #126) -- The father's appeal does not move MIRIAM. She says that she is determined to go with BRETT. LEE then for the first time realizes that there is something stronger between BRETT and MIRIAM than mere youthful affection.\n\nScene -129 INTERIOR. CLOSE-UP - of LEE - IN #128 - LEE wonders whether it is possible that his girl has fallen, --- his dear little light-hearted MIRIAM. His expression shows that the realization has come to him as a terrible blow.
s1229l11259	8	-3/A-\n\nScene -8 INTERIOR. (BACK INTO #6) HAZEL goes to BRETT and sneeringly\nasks who is the other woman. He protests that there\nis no other woman. HAZEL laughs and then threatens\nthat if he ever leaves her that she will squeal,\nand have him turned over to the police. BRETT\ndoggedly says he is determined to go --- to throw\nup the whole business. He is nervous and irritable.\n\nSUB-TITLE: BRETT SAID HE WANTED TO QUIT\nBECAUSE HE WAS TIRED OF BEING\nCROCKED, BUT THERE WAS ANOTHER\nREASON ------\n\nScene -9 EXTERIOR. SHADOW OF CALVERT. Tall and gaunt - and dressed\nin long frock coat and Stetson Hat -- is projected\non wall. Discovery finds the Shadow stationary,\nand sharply outlined in profile.\n\nScene -10 EXTERIOR. CLOSE-UP - of BRETT - his eyes fixed in terror\nas he realizes that the avenger is on his trail.\nHe has seen the Shadow on the wall.\n\nScene -11 EXTERIOR. (BACK INTO #9) Shadow of CALVERTx slowly moves\nout of the camera.\n\nScene -12 EXTERIOR. STREET CORNER. MEDIUM VIEW. BRETT turns x\nfrom observing VALVERT and fearfully turns corner.\nFADE\n\nScene -13 INTERIOR. FADE IN -- (BACK INTO #6) -- BRETT repeats his\ndetermination to get out and HAZEL sneers and\nrepeats her threat. The STONES try to smooth\nout matters, but BRETT'S mood is unchanged.
s1229l11259	47	-42-\n\nScene -230 INTERIOR. HALLWAY OF VILLA. (SAME AS #216) BRETT telling STONE how MIRIAM had balked on going through with the scheme. He is enraged and says that he is going to throw MIRIAM out, damn her! HAZEL comes on from the porch and BRETT tells her to go into the Living Room. She asks why BRETT and STONE are looking so sore. He says he will tell her later. She exits.\n\nScene -231 INTERIOR. (BACK INTO #229) MIRIAM'S BEDROOM. CLOSE-UP - of MIRIAM - sitting on the edge of the bed. She is contemplating her wedding ring. The certainty has grown upon her that it is false. She knows now that BRETT would be capable of such a dastardly deception. She will find out now and then should the worst be true --- what then? She had sent BURKE away; her home was closed to her; she was sickened of the life that was now revealed to her in all its hideousness. What --- she throws out her arms in a helpless, despairing gesture and starts.\n\nScene -232 EXTERIOR. ROAD AT ENTRANCE TO VILLA. BURKE is about to enter his machine. Pauses, frowns, debating. Yes --- his mind is made up --- he will go back and have a show-down with BRETT against whom his resentment has grown to the point of violence. Starts back.\n\nScene -233 INTERIOR. (SAME AS #203) LIVING ROOM OF VILLA. BRETT is telling HAZEL how MIRIAM has failed --- turned Puritan at the very time that BURKE might have been landed, and had thrown up the entire business. HAZEL laughs and says he should have expected something like this; that MIRIAM was still a little country fool, and, now that she had proved it she deserved all that was coming to her. She should be thrown out --- back to the farm.\n\n"And, that's what I am going to do", BRETT assures her. MIRIAM enters at this juncture. She is calm. She tells BRETT to send HAZEL away, that she wants to speak with him. BRETT says HAZEL stays. HAZEL says -\n\n"You act as though you own him, but you don't."\n\nMIRIAM replies - "I am his wife, am I not?"\n\nHAZEL laughs and sneers, pointing to MIRIAM'S wedding ring, telling her that it is worthless.\n\n"Wake up, you little boob!"
s1229l11259	10	-5-\n\nScene -20 EXTERIOR. The lawn of the LEE house. The two LEE kids are discovered with a dog. The boy has a paper hat on his head and carries a wooden sword. He is putting his sister through a drill but she is a bad pupil and he seriously reprimands her showing her how to carry her stick at shoulder arms, carry arms, etc. She finally rebels and throws down the stick. He gravely shakes his head and tells her that women are no good as soldiers. She tells him she doesn't care and sticks her tongue out. He points with a sword to the house and tells her to go in. She says she won't and that he cannot make her do so. She stands defiant with her little hands clenched and he relents, as she breaks into tears, and gallantly embraces and kisses her. They both laugh and turn to the dog, which she holds while the boy attempts to mount it, and do a Cavalry stunt. He slips off to the ground and the girl, holding the dog by the collar, shouts with laughter. He gets up, his childish dignity considerably upset and vows that he will ride the dog. In making this attempt the dog bolts and the girl is thrown to the ground and gets up with her dress soiled and in tears. MIRIAM comes down from the house, wipes the dirt from her little sister's face, soothes her and then, like a little mother, presses both of the kiddies' faces against her own and all three smile affectionately. FADE\n\nScene -21 INTERIOR. LEE'S BEDROOM. His wife's picture hangs over the mantelpiece. The old man stands contemplating it, with his hands behind him. He turns from the picture to the camera. The hard expression vanished from his face, and succeeded by one of tenderness and grief. The tears come into his eyes. He sits with his chin in his hand, recalling the future he had planned with his little family and in realizing that his wife is no more, is profoundly affected. He gazes off into space and sees ----\n\nand sees - FADE\n\nScene -22 FADE IN --- LEE'S sitting room -(same as #2) - LEE is, his wife and MIRIAM discovered. MIRIAM has on a new dress that her mother has just made for her, and both of the old folks are inspecting it. The mother, who has some sewing in her hand, indicates how the frock maybe improved here and there and MIRIAM is proud as she turns and shows it during the exhibition. The old man gives a brief approval and reaches for a book on the table. The two kids scamper in and pull MIRIAM off. The mother speaks to them cheerily as they exit. MRS. LEE comes and sits down on the other side of the table, reaches gently over, closes the book which
s1229l11259	46	-41-\n\nScene -225 INTERIOR. (BACK INTO #225) MIRIAM has risen, bewildered\nby the truth that is forcing itself upon her.\nBURKE takes her by both shoulders and speaks.\nShe does not try to break away, but seems to be\nswayed by the hopelessness of her case. Her eyes\nclose like those of a tired child's, and it seems\nas though she were about to fall limply into the\narms of the strong man. BURKE looks eagerly at\nher, as though he were ready to clasp her in his\narms, to hold her, to protect her, to be her strong\nrefuge. Their eyes meet for a brief second and she\nbacks away from him, sadly shaking her head. BURKE\nreminds her that if she ever needs a friend --- a\nreal friend --- he will always be at her call, but\nadvises her to shake the miserable gang with which\nshe is associated. She extends her hand to him and\nhe goes. Turning at the door, and striking his\nchest, assuring her that his heart is there for her,\nhe goes.\n\nScene -226 INTERIOR. HALLWAY OUTSIDE OF MIRIAM'S BEDROOM. BURKE opens\ndoor of MIRIAM'S room, comes out and goes. BRETT,\nwho has been watching from the door of a room further\nup the hall, comes down with a pleased expression\non his face, pauses at MIRIAM'S door and then enters.\n\nScene -227 INTERIOR. (BACK INTO #225) MIRIAM'S BEDROOM. BRETT enters.\nMIRIAM is standing looking toward the door but her\nexpression changes when seeing BRETT. He comes\ntoward her elated, complimenting her on landing\nBURKE. She is a clever girl. And he knew that she\nwould go through with it to the limit. MIRIAM is\namazed at the insinuation that she should have\nsurrendered herself and throws BRETT violently aside,\ncalling him a hound for having put her up for sale.\nLashes him for his infamy, the whole vileness of the\nlife into which he has led her coming before her.\nBIG SCENE --- he breaks out into a frenzy of abuse\nand strikes her. She falls, swooning to the floor.\nBRETT coolly lights a fresh cigarette, looking down\nat MIRIAM, and exits.\n\nScene -228 EXTERIOR. Flash - of CALVERT - in the road in front of\nBRETT'S VILLA. Just the characteristic figure in\nsilhouette.\n\nScene -229 INTERIOR. (BACK INTO #227) MIRIAM'S BEDROOM. She has risen\nunsteadily from the floor. Staggers to the bed and\nsinks upon it, holding her head between her hands.\nFADE OUT.
s1229l11259	3	©CIL 11259
s1229l11259	52	-47-\n\nScene -255  EXTERIOR.  GATEWAY OF LEE HOME.  Machine shot from outside\nof gate.  LEE, his expression eager and expectant,\nBARBARA and BURKE come into the picture.  BURKE\ncalls and the happy faces of MIRIAM and the KIDS\nappear at the window.\n\nScene -256  EXTERIOR.  CLOSE-UP - of MIRIAM and KIDS - framed in\nwindow of limousine.\n\nScene -257  EXTERIOR.  (BACK INTO #255)  LEE extends his arms and\nMIRIAM and the KIDS alight.  The old man clasps\nhis sobbing daughter to him.  The KIDS are joyously\nclinging to her.  AUNT BARBARA wipes her eyes and\nBURKE seems supremely happy.\n\nSUB-TITLE:  AND -----\n\nScene -258  INTERIOR.  SITTING ROOM OF LEE HOME.  (SAME AS #2)  LEE and\nBARBARA are sitting and MIRIAM, standing, is telling\nhow BURKE, the strong man, saved her and brought\nher to be received in again.  BURKE is sitting with\nthe KIDS in his lap.  MIRIAM finishes her story.\nThe old folks look thankfully and approvingly toward\nBURKE, and MIRIAM goes to him and lays her hand\ntrustingly on his shoulder.  The KIDS scramble down\nand insist that she kiss him.  Instead, he rises\nand taking her by both hands pledges himself to her\nfuture happiness.  LEE and BARBARA show that they\napprove.\n\nScene -259  INTERIOR.  CLOSE-UP - of BURKE and MIRIAM - IN #258 -\nHe holds her hands and she looks into his eyes\ntrustingly and happy.  Here at last, through tears\nand anguish and out of the darkness, she has come\ninto the light of real happiness.\n\nBEGIN TO FADE --- BURKE repeats the question that\nhe has asked her before.  She smiles radiantly, says\n"YES" and her head sinks toward him.\n\nOUT\n\nTHE END.
s1229l11259	23	-18-\n\nBRETT can be found. The KID understands. LEE tells\nthe child to say that HE has asked BRETT to the home.\nKID goes.\n\nScene -97 EXTERIOR. (CUT BACK TO #94) BRETT smoking, but impatient.\n\nScene -98 EXTERIOR. ROADWAY. Flash of SHADOW MAN going in search of\nBRETT.\n\nScene -99 INTERIOR. CLOSE-UP - of MIRIAM - IN #96 - anxiously looking\nout of the window.\n\nScene -100 INTERIOR. CLOSE-UP - of LEE - IN #96 - agitated, nervous\nbut stern. He feels that some great climax is at\nhand.\n\nScene -101 EXTERIOR. (CUT BACK TO #97) BOY comes into scene and\nseeing BRETT, first salutes, then says --\n"My sister wants you at the house."\n"Your sister?" questions BRETT.\n"Yes" - says the BOY.\nand takes him by the hand and they both start.\n\nScene -102 INTERIOR. (BACK INTO #96) SITTING ROOM. LEE is standing\nby the fireplace, moodily looking into the flames,\nand MIRIAM has come down from the window, just as\nthe boy and BRETT appear in the doorway of the room.\nBoth MIRIAM and LEE turn in surprise. There is sur-\nprise also on the face of BRETT, who thought he\nwould find MIRIAM alone.\n\nScene -103 INTERIOR. CLOSE-UP - of BRETT - IN #102 - expressing sur-\nprise and wonder if this might not be a trap.\n\nScene -104 INTERIOR. CLOSE-UP - of LEE - IN #102 - for one brief\nmoment the hard face of LEE irradiates with happi-\nness and relief that the man concerned with his\ndaughter is frank and honest enough to come to\nher home and meet her father; but his face immedi-\nately relaxes into its customary severity.
s1229l11259	9	-4-\n\nSUB-TITLE: THE SHADOW WAS A GRIM,\nMENACING REALITY.\n\nScene -14 EXTERIOR. DOOR-WAY. NIGHT. SHADOW MAN standing watching\nthe building opposite.\n\nScene -15 INTERIOR. (BACK INTO #6) The STONES and HAZEL are ready\nto go out for the evening but BRETT moodily says\nhe will stay behind. YES -- he will be there\nwhen they return. He wants to be alone. They\nstart and HAZEL turns and emphasizes her throat\nthat she will squeal if he leaves her.\n\nScene -16 EXTERIOR. (BACK INTO #14) SHADOW MAN starts as he sees\nthe STONES and HAZEL leaving house.\n\nScene -17 EXTERIOR. HOUSE - with taxi at curb - shot from the\nopposite side of the street. The STONES and HAZEL\nenter the machine, which goes.\n\nScene -18 EXTERIOR. (BACK INTO #14) SHADOW MAN has evidently\ncalculated on finding BRETT with party. Debates\na moment and then goes.\n\nSUB-TITLE: AN HOUR LATER.\n\nScene -19 INTERIOR. (BACK INTO #6) BRETT has travelling bag\npacked on table, fastens it, throws coat over his\narm, goes to window, looks out, then takes bag\nand starts. Turning at the door he says goodbye\nto the apartment, the life he has lived there and\nthe gang. Turns after last look.\nFADE OUT
s1229l11259	22	-17-\n\nScene -92 EXTERIOR. PORCH OF LEE HOME. Showing doorway. MIRIAM\ncomes out with her coat and hat and lays them one\nside and tiptoes back to the door. Just as she\nreaches the door, she is confronted by her father.\nShe shrinks away guiltily from him and as he inquires\nas to what she is doing. The old man sternly\npoints to where she has hidden her hat and coat\nand asks her what is the meaning of her actions.\nShe fumbles and tries to explain. Her father tells\nher to pick up the hat and coat and bring them in-\nside. He will have it out with her in the sitting\nroom. She gets hat and coat and follows him in.\n\nScene -93 INTERIOR. (BACK INTO #91) SITTING ROOM. LEE enters\nfollowed by MIRIAM. He orders the KIDS out of the\nroom and they go off at left.\n\nSpoken title; "Who is the man?"\n\n(BACK INTO SCENE) The realization that there is a\nman unknown to him who has come into MIRIAM'S life\nalmost dazes the old man. And, as he asks the\nquestion, MIRIAM begins lamely to tell of BRETT.\n\nScene -94 EXTERIOR. Flash back to #87 - BRETT impatiently waiting.\n\nScene -95 EXTERIOR. BUILDING WHERE BRETT HAS HIS ROOM. (SAME AS #57)\nSHADOW MAN is talking to the janitor, who tells him\nthe direction BRETT has taken.\n\nScene -96 INTERIOR. (BACK INTO #95) SITTING ROOM. MIRIAM is\nsilent under his father's questioning. He asks her\nwhy BRETT does not come to the house like an honest\nman. She gradually regains her self-possession and\nappears hurt that her father mistrusts her. She\nknows in her heart that she has asked BRETT to come\nto the house and he would not come. And, yet with\nthis knowledge, she boldly tells LEE that BRETT\nwould come if she had asked him to. Instantly,\nLEE takes her at her word, and calling off to the\nlittle BOY, goes to the door through which the KID\nexits. As LEE quickly pulls open the door, the KID\nwho has been eavesdropping, falls in on the floor.\nThe KID gets up confused and fearing some sort of\npunishment, starts to run off again, but the old man\nrestrains him. He asks MIRIAM to tell the BOY where
s1229l11259	20	-15-\n\nScene -77 INTERIOR. FADE IN --- SITTING ROOM. MIRIAM and girl\nfriend in animated conversation. MIRIAM rises and\nsays it is time to be going, but the girl forces\nher into her chair, saying that she sees so little\nof her that she must insist that MIRIAM prolong her\ncall. Her insistence overcomes MIRIAM'S objections.\nFADE\n\nScene -78 INTERIOR. FADE IN -- (CUT BACK TO #62) -- where MIRIAM\nlooks at clock while she LEE is asleep in the\nsitting room.\n\nScene -79 INTERIOR. CLOSE-UP - of CLOCK - IN #62 - This time it\nworks according to MIRIAM'S stay. nine o'clock.\nFADE OUT.\n\nScene -80 INTERIOR. FADE IN --- (BACK TO #76) --- LEE SITTING ROOM.\nMIRIAM tells her father she did not want to wake\nhim and so went up to bed. LEE is still suspicious.\nFADE\n\nScene -81 INTERIOR. LEE DINING ROOM. (SAME AS #49) LEE, MIRIAM and\nthe KIDDIES are at breakfast. MIRIAM, who is serving\nthe meal, is still nervous and fearful. Her father\neats in silence and the children, feeling that some-\nthing has happened, are awed into silence. They are\nafraid of the old man. LEE rises and goes. MIRIAM\ngoes to the door to see that he leaves the house.\nThen, when she is sure of it, she turns and telling\nthe children to stay where they are until she returns,\nshe exits.\n\nScene -82 INTERIOR. LEE SITTING ROOM. (SAME AS #2) MIRIAM comes in\nand goes to telephone and calls.\n\nScene -83 INTERIOR. CLOSE-UP - of girl IN #77 - at telephone. She\nexpresses surprise at MIRIAM'S request, and wonders\nwhat it is all about.\n\nScene -84 INTERIOR. CLOSE-UP - of MIRIAM IN #82 - MIRIAM implores the\ngirl to lie for her if questioned and to say that\nshe -- MIRIAM -- had spent the evening at her house.\nShe would explain all later, etc.
s1229l11259	51	-46-\n\nScene -249 EXTERIOR. LEE HOME. SUNDAY. LEE is returning from church with AUNT BARBARA and the KIDS, who are walking primly, arm in arm, and in their best bib and tucker. At the gate four other church goers pause to say good day and the LEE party go up to the house.\n\nScene -250 INTERIOR. PORCH OF LEE HOME. Old folks and KIDS come up. AUNT BARBARA takes KIDS inside and LEE takes off hat and sits in chair. Moodily looks at open door and then off. Sadly shakes his head. Looks curiously down to gate as he sees automobile stop.\n\nScene -251 EXTERIOR. PATHWAY AND GATE OF LEE HOME. Shot from the porch. Limousine has stopped and BURKE alights and starts up.\n\nScene -252 EXTERIOR. (BACK INTO #250) BURKE comes on porch. LEE rises to greet him. BURKE introduces himself. Old man politely attentive and wondering the purpose of the visit. Men are standing, as KIDS come out and seeing the machine, decide to look it over. They go. The men sit.\n\nScene -253 EXTERIOR. PATHWAY TO GATE. (SAME AS #251) The KIDS are romping down to the machine.\n\nScene -254 EXTERIOR. (BACK TO #252) BURKE mentions MIRIAM and the old man's hard face lights up. He feels that here, by Divine ordering, he is about to learn of his lost one. He tells how his anger was roused against her and he banished her at that very door near which they sat. Would he forgive her? With his whole heart -- only to hold her in his arms! AUNT BARBARA joins them and adds her word. BURKE asks them to follow him. They start.\n\nSUB-TITLE: AFTER "SEVEN DAYS".
s1229l11259	53	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l11259	32	-27-\n\nScene -149  INTERIOR.  CLOSE-UP - of MIRIAM - IN #148 - study of\nexpression - wonder, surprise and a pretty\nbewilderment.\n\nScene -150  INTERIOR.  CLOSE-UP - of various characters - IN #148 -\nwho are sizing MIRIAM up and discussing her.\n\nA-  Blase old sport, with world-worn\npainted, daringly dressed woman.\nHe with gloating expression; she\nwith supercilious contempt and ill-\ndisguised envy.  She notes his\nexpression and calls him down.\n"Here, stop rubbering at that chicken\nand drink your wine!" says she, or\nwords to that effect.\n\nB-  Two tango Tessies.  Look, criticise,\nMIRIAM'S frock; whisper, smile\nknowingly, and giggle.\n\nC-  Bejeweled old dame, dressed like a\ngirl, with lorgnette and makes a cold\nsniffs contemptuously.  The yo knows\nfrank admiration.\n\nD-  Respectable appearing old chap - might\nbe a banker or merchant - with young,\nwise Girl of the Night.  She is chatter-\ning and using her stock blandishments.\nHe is looking toward MIRIAM with senile\ndesire.\n\nE-  HAZEL HART.  She expresses pique and\njealousy.\n\nScene -151  INTERIOR.  (BACK INTO #148)  Meal is on the BRITT table.\nWine.  MIRIAM hesitating, takes her first drink\namid banter and merriment.\n\nScene -152  INTERIOR.  LEE DINING ROOM.  SAME AS #49.  LEE and KIDS\nat meal.  AUNT BARBARA, LEE'S sister, is officiating.\nIt is a scene of peace and simplicity.  BARBARA,\na kindly old soul, is doing her best to cheer up\nLEE, who eats in silence.  She has business with\nKIDS.\nFADE.
s1229l11259	25	-20-\n\nScene -112  INTERIOR.  (BACK INTO #110)  BRETT in abject fear, says\nto LEE --\n"For God's sake, hide me somewhere!"\n\nBoth MIRIAM and her father are amazed.  And, BRETT,\nlike a haunted animal, looks around for an avenue\nof escape from the SHADOW MAN, whom he knows is on\nthe other side of the window.  LEE motions him to\nthe room at right and BRETT swiftly goes.  MIRIAM\ncloses the door behind him.  LEE goes to the window\nand swings it open.  The SHADOW MAN steps in,\nremoving his hat and apologizing, asks to be told\nwhere BRETT is.\n\nScene -115  INTERIOR.  ROOM IN LEE HOME OFF SITTING ROOM.  BRETT\nhastily scribbles a note, places it on the table,\nraises the window and vaults out.\n\nScene -114  INTERIOR.  (BACK INTO #112)  SITTING ROOM.  LEE has asked\nSHADOW MAN to come in and take a seat.  MIRIAM\nregards CALVERT with a fear for which she can\nascribe no reason.  In the figure, however, she\ndoes see a suggestion of mystery and tragedy.\nSHADOW MAN comes down, but refuses to sit, and he\nstands by the fireplace.\n\nScene -115  EXTERIOR.  ROADWAY.  BRETT running as though the devil\nwere after him.\n\nSUB-TITLE:  WHAT BRETT DID NOT TELL MIRIAM.\n\nScene -116  INTERIOR.  CLOSE-UP - of CALVERT - IN #114 - speaking.\nFADE OUT\n\nScene -117  INTERIOR.  DINING ROOM OF THE CALVERT RANCH HOUSE.  CALVERT\nand wife seated at meal.  BRETT, in cowpuncher's\ndress, enters and gives note to CALVERT, who reads it.\nTells BRETT to wait and exits.  BRETT converses with\nMRS. CALVERT and she shows that she is in love with\nhim.  Squaw servant watches him through through window.\nCALVERT on returning, almost catches them in an\nembrace.  The men exit.\nFADE
s1229l11259	17	-12-\n\nScene -52 INTERIOR. (BACK INTO #50) BOY sits on floor with pie between his legs, gorgeing himself with it.\n\nScene -53 INTERIOR. (BACK INTO #46) BRETT'S ROOM. BRETT and MIRIAM on. They are sitting. He has his arm about her and is telling her of his devotion and the wonders of the big city. She is charmed, but begins to show uneasiness.\n\nScene -54 INTERIOR. (BACK INTO #49) LEE DINING ROOM. LEE enters and is amazed to see the little girl arranging table. Asks for MIRIAM. Child does not know where she is. He calls off and getting no answer, turns into the room again. BOY appears in kitchen door, his face smeared with pie filling. LEE angered and amazed. FADE\n\nScene -55 INTERIOR. (BACK INTO #55) BRETT'S BEDROOM. MIRIAM is anxious to go. BRETT is exacting a promise from her to call again. She is trying to persuade him to call at her home and meet her father. They go into an embrace at the door and she goes. He comes down full into the camera, smiling in triumph at his conquest. FADE\n\nScene -56 INTERIOR. CHILDREN'S BEDROOM. LEE HOME. OLD LEE has just tucked the children in bed. He turns out the light.\n\nScene -57 EXTERIOR. NIGHT. BUILDING in which BRETT has his room. MIRIAM comes out, glances warily about and goes.\n\nScene -58/60 INTERIOR. LEE SITTING ROOM. (SAME AS #2) LEE cannot understand what has happened. He is torn with doubt and fear. His daughter is the apple of his eye and he hopes that she will be able to give a satisfactory explanation of this strange absence. Had she done something forbidden? The man is in a torture of anxiety. He settles back in the chair and his lips move in prayer. FADE\n\nScene -61 INTERIOR. HALLWAY OF LEE HOME. MIRIAM stealthily comes in. She tip-toes to the entrance to the sitting room and looks in. She is guilty and fearful.
s1229l11259	5	SUB-TITLE: MIRIAM LEE.\n\nScene -1  IRIS - MIRIAM - She wears a house-working apron, which covers her dress, and is standing in the hallway of the LEE home, sending her five year-old brother and seven year-old sister to school.  She is discovered speaking to them and smiling.  As she bends over to adjust the tie of the boy, the diaphragm opens and takes in complete medium scene.  The door giving onto the porch is opened and gives a view of the exterior.  The children have their books and MIRIAM produces two apples for their luncheon.  The largest of these is given to the boy.  He immediately calls MIRIAM'S attention to it, and gallantly exchanges with his sister.  MIRIAM approves his gallantry and affectionately pats him on the back.  He raises his face to be kissed, she kisses him, and kisses the girl, who starts away first.  But the boy stops her, stands in front of her and, saluting MIRIAM in military fashion, marches away with soldierly step, the girl falling into the step and holding herself erect as a little soldier.  They go out of the door with MIRIAM sending them a cheery, laughing, goodbye.\n\nSUB-TITLE: ALDEN LEE, MIRIAM'S FATHER, UNCHANGED THROUGH THREE HUNDRED YEARS OF PURITAN ANCESTRY.\n\nScene -2  INTERIOR.  SITTING ROOM OF LEE HOME.  IRIS - LEE - He is sitting at table reading Bible and raises his head for full view in camera.  His face is set, grim, and mirthless, as though carved of New England granite.  He has his finger on the book and turns again to the passage he has been reading.  Looks up, moodily shaking his head in resignation and rises.\n\nDiaphragm opens - disclosing set.  There is a full length window opening off the porch at center.  A door at upper right and fireplace further down on right.  There is a door on the left.  The table stands near the fireplace.  As the entire scene is revealed, MIRIAM is discovered entering from right, with her father's hat and cane.  She approaches him smiling and sprightly, and with an expression of marim tenderness which is in no manner reflected by her father.  He takes the hat and cane with old-fashioned courtesy, and thanking her, and giving some directions concerning the house, starts off.  At the door it seems as though MIRIAM is about to embrace
s1229l11259	35	-30-\n\nSUB-TITLE: "THAT'S THE MAN!"\n\nScene -164 INTERIOR. CLOSE-UP - of MIRIAM and MRS. STONE. BRETT and STONE with heads together, speaking. The elder woman is speaking and both look toward the millionaire, as do BRETT and STONE. It is plain that the two men are planning to "trim" BURKE.\n\nScene -165 INTERIOR. CLOSE-UP - of BURKE - IN #163 - and the singing girl.\n\nScene -166 INTERIOR. (BACK INTO #163) MRS. STONE makes a suggestion to MIRIAM. She nods, takes a rose from the table, and throws it.\n\nScene -167 INTERIOR. CLOSE-UP - of singer - IN #163 - the rose strikes her and falls --.\n\nScene -168 INTERIOR. CLOSE-UP - of BURKE - IN #163 - rose falls into his lap, or on table. He picks it up and looks toward MIRIAM.\n\nScene -169 INTERIOR. CLOSE-UP - of MIRIAM - IN #163 - smiling, coquettishly, challenging.\n\nScene -170 INTERIOR. CLOSE-UP - of BURKE - IN #163 - showing the first trace of interest. His eyes suddenly widen as he looks at MIRIAM. He is instantly interested.\n\nScene -171 INTERIOR. CLOSE-UP - of MIRIAM - IN #163 - coquettishly conscious of the attention she has attracted, but finding she is unable to withstand the power in the gaze of the man.\n\nScene -172 INTERIOR. CLOSE-UP - of BURKE - IN #163. Glance fixed, unwavering.
s1229l11259	6	-2-\n\nhim, but the old man's manner is so absorbed, so\nuninviting that she restrains herself, and as he\nexits she comes down with a wistful expression on\nher face. She makes it evident that here is an\naffectionate girl, like most girls full of dreams\nof romance, and who naturally crave for love, who\nis simply hungry for the affection which she does\nnot receive in the barren confines of her New\nEngland home. She is starving for it, but bravely\nand cheerfully carries out her duties as the "little\nmother" and feminine head of the house since the\ndeath of MRS. LEE.\n\nScene -3 INTERIOR. CLOSE-UP - of MIRIAM - showing loneliness and\nyearning - then she breaks suddenly into a sunny\nsmile and tosses her head as though she had mentally said -\n"Oh, what's the use?"\n\nScene -4 INTERIOR. (BACK INTO #2) MIRIAM runs to the window to see\nif her father is well on the way -- then comes down\nand raising up the cushion of one of the easy\nchairs, takes from underneath a novel that she had\nconcealed there. She replaces the cushion, sits and\nreads.\n\nVISION IN - double exposure - Cowboy and girl\nriding toward camera. Stop, cowboy reaches over\nand embraces girl. VISION FADES---\nMIRIAM pauses in reading.\n\nScene -5 INTERIOR. CLOSE-UP - of MIRIAM - her eyes bright and her\nface expressing a sort of ecstasy as she visualizes\nthe romance.\nPADE\n\nSPEAKER-TITLING\nSUB-TITLE: TOM BRETT, AN ESTEEMED MEMBER\nOF THE UNDERWORLD, _______________
s1229l11259	49	-44-\n\nsecuring the gun from the wall, slips in a cart-\nridge and levels it at BURKE'S back. MIRIAM\nturns and seeing the action, shrieks and clings\nto BURKE. Just at this juncture, a shot is fired\nthrough the window at right and BRETT crumples up\nand falls. HAZEL falls sobbing over his body.\nThe STONES and the other guests come in and stand\nawe-stricken. Projected against the large center\nwindow by the moonlight appears the shadow of CALVERT\nwalking across the line of vision with gun in hand.\nBURKE leads MIRIAM off.\nFADE\n\nScene -240 EXTERIOR. INTERSECTION OF TWO SUBURBAN ROADWAYS. Policemen\nat corner. SHADOW MAN comes on, gun in hand, and\ntells that he has shot BRETT. Motioning back,\ncop calls off for man on opposite beat, and takes\nCALVERT'S gun. Second cop comes and the three\nstart back.\n\nSUB-TITLE: ALDEN LEE, RELENTED AND YEARNING\nFOR THE LITTLE MOTHER, FINDS A\nMESSAGE IN THE BOOK.\n\nScene -241 INTERIOR. LEE SITTING ROOM. (SAME AS #2) LEE at table,\nwith Bible and AUNT BARBARA with her knitting.\nLEE reads and then raises his head in thanksgiving.\nHis hard face lighted with hope. He joyously draws\nBARBARA'S attention to the text.\n\nScene -242 INTERIOR. CLOSE-UP - of 12th chapter of NUMBERS - Show\n10th verse, finger moving under the underscored\nwords ---\n10- And the cloud departed from off the\ntabernacle; and, behold MIRIAM became\nleprous, white as snow; and Aaron looked\nupon MIRIAM, and, behold, she was leprous.
s1229l11259	15	-10-\n\nScene -40  INTERIOR.  CLOSE-UP - IN #38.  MIRIAM reaches up and takes\ndown the gun.  Holds it from her gingerly, and\ninspects it.  Walks down.\n\nScene -41  INTERIOR.  (BACK INTO #38)  MIRIAM holds up gun and says she\nwonders what romances are connected with it.  He\ntakes it, looks at it affectionately.  Both sit.\nHe begins his story.\nFADE OUT\n\nSUB-TITLE:  AS BRETT TOLD IT.\n\nScene -42  EXTERIOR.  OUTSIDE OF COWTOWN DANCE HALL.  Crowd of men and\nwomen sunning themselves.  A big bad-man -- a twogun\nfighter -- slaps a girl and no one seems willing to\ninterfere.  Bad man looks defiantly at crowd, hands\non gun.  BRETT coolly advances, cigarette in mouth.\nBad man swears while the crowd falls away.  BRETT\nlands a lightning wallop to the jaw, which lands\nthe fellow on his back.  Dazed, he sits up, reaching\nfor his guns, but is covered by BRETT, who orders\nhim to his feet.  Disarms him and drives him off.\nFADE\n\nScene -43  INTERIOR.  CLOSE-UP - of BRETT and MIRIAM - IN #41.  He\ntelling story.\nFADE\n\nScene -44  INTERIOR.  FADE IN -- camera shows both sides of street.\nCowboys - companions of BRETT - mount horses and go.\nBRETT is the last of the crowd to get away, and\njust as he swings his pony about, the Bad Man, on\nthe other side of the street, opens fire.  BRETT'S\nhat flies off.  BRETT fires three shots in rapid\nsuccession, and the Bad Man reels and falls.\nFADE\n\nScene -45  INTERIOR.  FADE IN -- (BACK TO SCENE #43)  CLOSE-UP - of\nBRETT and MIRIAM - seated side by side - he still\nspeaking and she hanging on his words like one\nfascinated.\n\nScene -46  INTERIOR.  (BACK INTO #41)  MIRIAM rises, comes forward,\nspeaking as though inspired.  Throws her\narms up in a gesture of rebellion of freedom.\nBRETT comes down to her, and declares his love.\nSeizes her in his arms and kisses her again and again.\nHe gathers her up and crushes her to him.  FADE OUT
s1229l11259	40	-35-\n\n(BACK INTO SCENE) Valet enters and takes message\nfrom BURKE.\n\nScene -194  INTERIOR.  MIRIAM'S Boudoir.  (SAME AS #158)  She is\ndiscovered lingeried and prettily capped, just\nfinishing breakfast in bed, served by maid.\nPicture of indolent luxury.  BRETT enters,\nsmoking his inevitable cigarette.  He begins to\nquestion her regarding BURKE.  She seems list-\nless and indifferent.  She has the maid hand her\na newspaper.  BRETT getting sore.  MRS. STONE\nbustles in.  Business between the two women.\nMRS. STONE rallies her and asks to see the\nserpent crown.  MIRIAM reluctantly consents.\nMaid brings case.  MRS. STONE closely examines\njewel and rhapsodizes over it.  Sneer on BRETT'S\nface as he narrowly watches MIRIAM.  He is won-\ndering if she contemplates double-crossing him\nin the game.  MRS. STONE insists that MIRIAM\nput the crown on her head, which she wearily\ndoes.  She seems bored by the operation.  Then\nMRS. STONE tries it on, with business.  MIRIAM'S\nthoughts go back to the KIDS.\nFADE\n\nScene -195  EXTERIOR.  FADE IN --- GARDEN AND SEAT.  LEE HOME.  MIRIAM\nis sitting with her lap full of flowers and the\nlittle girl is placing a rudely made garland on her\nhead.  Boy salutes with his wooden sword.  Girl\njumps from seat and drops a courtesy before MIRIAM.\nThen they laugh and mount on either side of her on\nthe seat.\nFADE\n\nScene -196  INTERIOR.  FADE IN --- (BACK INTO #194)  BRETT has left\nthe room.  MRS. STONE bids goodbye to MIRIAM and\nexits.  MIRIAM knits her brows, takes up the crown\nthat lies beside her, looks at it in moody con-\ntemplation.\n\nSUB-TITLE:  THE MENACE IN THE NIGHT.
s1229l11259	38	-53-\n\nScene -184 INTERIOR. MIRIAM'S BOUDOIR. (BACK INTO #180) BURKE and MIRIAM. He leans toward her and speaks. She draws away, raising her hand in mock admonition, as she tells him not to become too bold. He laughs and tells her he would dare anything for what he desired - for her. But he is frankly admiring and considerate. He sees that MIRIAM should have no place in the crowd with which she is associated.\n\nSUB-TITLE: "You'd have been a widow long ago, had you lived in the West."\n\n(BACK INTO SCENE) MIRIAM'S BOUDOIR. BURKE takes a shot at MIRIAM'S worthless husband, and when he utters the word WEST, MIRIAM gives a slight start and searches him with her eyes, all in a flash, but it does not escape BURKE. He wonders why it affected her so.\n\nScene -185 INTERIOR. Flash - of HAZEL - meditating how she can strike at MIRIAM. She makes up her mind to hit MIRIAM through BURKE. Fade.\n\nSUB-TITLE: BURKE RECEIVES AN UNEXPECTED CALLER.\n\nScene -186 INTERIOR. BURKE'S SUITE IN HOTEL. Seated at table, opening letters when valet announces HAZEL. He seems surprised. She is shown in. She is easy, self-possessed and vivacious. BURKE suave and polite, but waiting to learn the motive of the call. HAZEL is frivoling, but it is seen that she has touched on MIRIAM and the jewel crown. BURKE speaks in warm appreciation of MIRIAM'S character. HAZEL sneers and tells BURKE to go ahead and win out MIRIAM in spite of whatever bluff she may put up.\n\nSpoken title: "Yes --- she thinks she's a wife!"\n\n(BACK INTO SCENE) HAZEL tells BURKE the story of the false marriage, as if it were a joke. BURKE represses the flame of his indignation and politely rises and ends the interview. HAZEL is in no way abashed, and exits blithely. BURKE watches her go with set jaws, and he meditates. FADE\n\nScene -187 INTERIOR. FADE IN - CLOSE-UP - of MIRIAM. She is extending her left hand regarding her wedding ring with an expression of fidelity. FADE OUT
s1229l11259	12	-7-\n\nScene -28 INTERIOR. (BACK INTO #24/25) SHADOW MAN has shoved STONE aside and enters the room, closing the door behind him. MRS. STONE is fearful but HAZEL is merely curious as to what this new development might be, but is bent on getting square with BRETT. The SHADOW MAN demands to know where BRETT is. Both of the STONES say they do not know, and HAZEL, who has made up her mind and flaming with anger, comes forward and is about to tell where he might be found. STONE seizes her, tells her to be silent. She passionately replies that she does not intend to be cast off and that no excuse can save BRETT --- that if he had to go away that she should have been taken along; that she had long been his pal --- that she had made every sacrifice for him, and now to be left flat --- she would squeal on him --- he deserved it. He was a yellow quitter. Both STONE and his wife, realizing that the woman is in deadly earnest, and fearing to lose all chance of ever having BRETT work with them again, determine at all hazards to prevent HAZEL from carrying out her threat. STONE releases his hold on her, and calmly says ---\n\n"Now, if you will squeal, we will do some squealing too."\n\nHe threatens to tell of a job in which she was concerned, in which the police had made no arrest and were still searching for the offender, and in the meantime, MRS. STONE had seized HAZEL telling her that she must be crazy and that if it came to a showdown, she, herself, would testify against her, and take the consequences.\n\n"We are all together and should pull together. For heaven's sake, don't be a squealer, and we will be all right, if you just keep your mouth shut."\n\nUnder STONE'S threat and denunciation, HAZEL wilts and bursts into tears. She tells the SHADOW MAN that she has no idea where BRETT has gone. The SHADOW MAN, who had hoped to find BRETT in this place where he had definitely traced him, is bitterly disappointed. He stands grimly silent, looking at the trio and at the aspect of the man they fall silent with something of fear in their hearts, as he speaks. He solemnly raises his hand and says that he will get BRETT, if he has to follow him to the end of the earth. His whole life is devoted to the quest.\n\nBEGIN TO FADE -- as SHADOW MAN is about to exit, his hand upraised, and the STONES and HAZEL watching him as though fascinated.\n\nFADE OUT
s1229l11259	36	-31-\n\nScene -173 INTERIOR. CLOSE-UP - of MIRIAM - IN #163 - fluttering, nervous, beaten down by the tremendous power of the steam-roller man. She is like a "bird in the fascination of a snake."\n\nScene -174 INTERIOR. (BACK INTO #163) Singer is returning to the stage, amid general applause. Friend comes to BURKE'S table, and greets him. BURKE rising. As the two stand, BURKE motions furtively to BRETT'S table, and asks who MIRIAM is. Friend volunteers to take him over and introduce him to the party. They go over. BURKE is first introduced to BRETT. They shake.\n\nScene -175 INTERIOR. CLOSE-UP - of BURKE and BRETT - IN #174 - being introduced. BRETT still with cigarette in his mouth. BURKE gives him a quick, searching glance, as though endeavoring to place him in his recollection.\n\nScene -175/A INTERIOR. (BACK INTO FULL SCENE #174) BURKE is given a seat beside MIRIAM.\n\nScene -176 INTERIOR. CLOSE-UP - of BURKE and MIRIAM - IN #174 - He is extending the rose. She seems flattered at what he is saying, but is disconcerted under his overwhelming glance. Here, indeed, is a big, powerful man, a masterful brute, such as she has never encountered before. She has begun to play a game, feeling that this man is the master. In his face is baffling, unexplored character. Had she been a woman of less intelligence, she likely would have underrated the hazard.\n\nScene -177 INTERIOR. CLOSE-UP - of BRETT and STONE - IN #174 - they show satisfaction that MIRIAM is landing the golden "fish".\nFADE\n\nScene -178 INTERIOR. (BACK INTO #174) BURKE and MIRIAM are looking at each other across their wine glasses. STONE watching with stealthy satisfaction. BRETT indifferent to it all under the influence of HAZEL, who has joined the group. MRS. STONE is talking to a bedizened old woman rounder, who has stopped at her chair.
s1229l11259	7	-3-\nScene -5/A INTERIOR. SITTING ROOM OF STONE'S APARTMENT. IRIS BRETT smoking cigarette. He is listening to argument by STONE and MRS. STONE and HAZEL against him quitting the game. Is sullen. Puffs and shakes his head emphatically.\nCLOSE OUT\n\nSUB-TITLE: HAZEL HART, A WHITE LIGHT WASP.\n\nScene -5/B INTERIOR. IRIS HAZEL. She is surprised and suspicious of BRETT'S declared intention of quitting. Brooding and undecided just what to do.\nCLOSE OUT\n\n"Chicago"\nSUB-TITLE: SID STONE AND HIS WIFE.\nVETERANS OF THE SEAMY WAY.\n\nScene -5/C INTERIOR. IRIS STONE and WIFE. STONE is speaking with emphasis and she is nodding approval.\nCLOSE OUT\n\nScene -6 INTERIOR. OPEN OUT INTO SITTING ROOM OF APARTMENT - Complete scene. Whiskey bottle, syphon of seltzer and glasses on table. BRETT, MR. and MRS. STONE and HAZEL HART discovered. BRETT is declaring his determination to leave and MR. and MRS. STONE are hotly arguing against it. STONE says that after having worked so long with them, it seems as though he were about to throw them down. HAZEL, who has regarded BRETT suspiciously, comes to a sudden conclusion.\n\nScene -7 INTERIOR. CLOSE-UP - of HAZEL - as she thinks that there maybe another woman in the case, and that BRETT contemplates deserting her. She is convulsed with suspicion and jealous rage.
s1229l11259	4	CAST OF CHARACTERS\n\n"THE SOUL OF SATAN"\n\nMIRIAM LEE - Daughter of ALDEN LEE, old New England lawyer. Little mother in the home of her widowed father. Romantic small town girl.\n\nALDEN LEE - MIRIAM'S father. Grim Scotch type, but devoted in his austere fashion to his little family. Knows much law and the Bible, his closest friend.\n\n"SULLION" BURKE - Western millionaire and man of the world. Steam-roller, aggressive type, imperturbable and adroit, but dead square.\n\n"TOM" BRETT - A good looking young crook. Polished and insinuating, with a dash of manner attractive to women. Unscrupulous fellow. Inveterate cigarette smoker.\n\nAUNT BARBARA - LEE'S maiden sister.\n\nCALVERT - The "shadow man". Ranchman, bent on vengeance because of a wrecked home. The Nemesis of the story, shown mostly in shadow.\n\n"CHICAGO" SID STONE - Gentle type of blackmailer, gambler, crook and high-living wire-tapper. A middle-aged bird of prey.\n\nKATE STONE - Wife of SID. Former beauty -- now faded. Not without graciousness and tact. A veteran adventuress who has "played the game to the limit!"\n\nHAZEL HART - White light wasp --- in love with BRETT. Brunette, full of fire; "heavy" type and capable of carrying strong scenes.\n\nLEE KIDDIES - 5 year old boy and seven year old girl.\n\n----------
s1229l11259	29	-24-\n\nScene -135 EXTERIOR. DOOR OF LEE HOME. PORCH. Door is open. MIRIAM steps out, turns to speak, hand of LEE drops traveling bag at her feet and as she is about to speak, the door is shut in her face. This exceeds even the worst she expected, and MIRIAM leans against the door weeping.\n\nScene -136 INTERIOR. KITCHEN OF LEE HOME. (SAME AS #50) KIDS come on from the dining room where they had been listening to what transpired. They are serious and they seem to be on the verge of tears. They are determined that MIRIAM shall not go without bidding them goodbye. They tiptoe to the kitchen door and go out.\n\nScene -137 EXTERIOR. (BACK INTO #135) MIRIAM regains her composure, and thinks of the children. She is about to knock on the door, and beg father that she may say farewell to them, but changes her mind. And, choking back a sob, she takes the bag and goes down the steps.\n\nScene -138 EXTERIOR. LEE HOMESTEAD. Viewed from the gate. MIRIAM is seen coming down and nearly reaches the gate. The KIDS are seen to come from the side of the house and race down toward her. She hears them coming, drops her bag and extends her arms.\n\nScene -139 EXTERIOR. VIEW OF THE GATE FROM THE LAWN. The KIDS rush into MIRIAM'S arms and she clasps them to her. They say that she must not go --- that she must come back --- and pull at her, pull with the tearful, pathetic insistence of a child that knows that he is about to lose something very dear to him. MIRIAM is almost moved to return and beg for forgiveness, but she realizes that the die is cast beyond recalling. She tells the children that they must go back but they cling to her and ask her to take them with her. She smiles sadly and disengages herself. NO -- they must go back and she will return some day. She kisses each of them hysterically with, and with a sudden quick motion, grasps her bag and goes through the gate.\n\nScene -140 EXTERIOR. GATE FROM THE OUTSIDE. (SAME AS #138) MIRIAM has closed the gate, telling the children to go. Both of them burst into tears but bravely start back toward the house. MIRIAM tearfully watches them and turns toward the camera, her face set with determination to face bravely the world of the unknown into which she is going.
s1229l11259	43	-38-\n\nScene -213  EXTERIOR.  (BACK INTO #211)  BURKE and MIRIAM.  He\nmakes jocular remark on the love scene.  Her\nface hardens and she faces about.\n\nScene -214  EXTERIOR.  (SAME AS #212)  From another angle, BRETT and\nHAZEL still clutched.  In the middle distance\nare seen BURKE and MIRIAM walking back to the\nhouse.\n\nScene -215  EXTERIOR.  PORCH.  (BACK INTO #210)  BURKE and MIRIAM\nreturn.  MR. and MRS. STONE engage them.  MRS.\nSTONE to MIRIAM and STONE to BURKE.  STONE\nleads the Westerner aside, explaining some\ndetails of the plan by which it is calculated\nto induce him to part with his money.  MRS.\nSTONE notes the mood of MIRIAM, questions her,\nand the two women exit into the hall.\n\nScene -216  INTERIOR.  HALL OF VILLA.  Enter MRS. STONE and MIRIAM.\nThe latter wearily indicates that she is going\nupstairs and ascends.\n\nScene -217  INTERIOR.  MIRIAM'S BEDROOM IN VILLA.  MIRIAM enters and\nthrows herself on lounge.  Resentment, humiliation,\nfierce anger and irresolution shown.  She cannot\ndecide what she will do.\n\nScene -218  INTERIOR.  CLOSE-UP - of MIRIAM - IN #217 - She gestures\nhopelessly and buries her head in the pillows.\nFADE OUT\n\nScene -219  INTERIOR.  (BACK INTO #217)  BURKE enters at door; stands\nand speaks.
s1229l11259	31	-26-\n\nScene -145  INTERIOR.  CLOSE-UP - of HAZEL and MR. and MRS. STONE - IN #144 - MRS. STONE tells her not to be foolish --- that the newcomer means money to them; that BRETT still cares for HAZEL and that HAZEL should not let sentiment interfere with business. STONE interposes to say that with MIRIAM they are likely to clean up big in a single operation. And, when that is once accomplished, BRETT will let her go. HAZEL listens cynically but is apparently won to the argument.\n\nScene -146  INTERIOR.  (BACK INTO FULL SCENE #144) HAZEL and the STONES come down and join BRETT and MIRIAM, who is presented to HAZEL, who smiles upon her with something of contempt. The STONES engage MIRIAM while BRETT steps aside with HAZEL and tells her to be sensible and see the thing through --- she is the only woman that cuts any figure with him, or who ever will. HAZEL reluctantly yields. BRETT exits to the adjoining room.\n\nScene -147  INTERIOR.  ANTE-ROOM OF THE FLAT.  A man is dozing in the chair beside table - there is a bottle, several glasses, and a package ettes.  He is a member of the gang and is to perform the spurious marriage. BRETT rouses him. The man takes bundle off chair, and producing ministerial coat and vest, begins to don them. Buttons up, regards himself in the mirror, clasps his hands in front of him in a mock pious air, asks BRETT what he thinks of the imitation and starts to go. FADE.\n\nSUB-TITLE:  THE "WEDDING DINNER".\n\nScene -148  INTERIOR.  INTERIOR OF TANGO PALACE.  Usual arrangements of tables and dancing space in center. Orchestra elevated up C.  Stage fully dressed with diners. BRETT, MIRIAM and STONES and HAZEL, with a fellow, come down to table, exchanging greetings with several persons on the way.  Except MIRIAM, they are well known in the place.  Order the meal. MIRIAM shy and curious in the unfamiliar surroundings, but conspicuous for her simple, girlish dress and her ingenuous manner.
s1229l11259	28	-23-\n\nScene -150 INTERIOR. CLOSE-UP - of MIRIAM and LEE - IN #128. LEE\ngrasps MIRIAM by the shoulders and squarely faces\nher. He demands that she answer and look him in\nthe eye. She makes a pathetic struggle to look\nup into his questioning, eager face --- he is\nhoping against hope --- but she cannot. Her eyes\ndrop.\n\nScene -151 INTERIOR. (BACK INTO FULL SCENE #128) LEE releases her\nand staggers back as though shot. He realizes\nthat she has given herself up to BRETT. MIRIAM'S\nhead drops upon her breast and she falls limp against\nthe table. LEE is awakened to a sudden frenzy and\ndeclaring that he never wants to see her face again,\ndashes from the room. MIRIAM pauses - then unsteadily\nexits.\n\nScene -152 INTERIOR. SITTING ROOM. (BACK INTO #125) MIRIAM enters\nfrom left, comes on unsteadily and stands. This\ntragic thing has come to her with the suddenness of\na lightning flash. She realizes that she is being\nseparated from what has been up to this time the\ndearest pieces on earth --- with the memory of mother --\nand the sweet compelling love of the children, and\nthe constant protection of her stern father, --- her\nfather after all. She was now facing the unknown\nfor a passion that had swept her from her feet, but\nhad nevertheless, opened up new hopes and dreams for\nher. And, yet, realizing with keenest anguish, the\nhazard of the days to come with this man, who was\nunworthy but whom she loved to the limit of sacrifice,\nshe felt that her future was full of foreboding.\nBut she would go with him, --- that was settled beyond\nrecall. She limply sinks into a chair and buries her\nhead in her hands.\n\nScene -153 INTERIOR. MIRIAM'S BEDROOM. (SAME AS #64) LEE, in a mad\nfrenzy, is stuffing some of MIRIAM'S belongings\nin a traveling bag. He closes it and starts.\n\nScene -154 INTERIOR. (BACK INTO #152) SITTING ROOM. MIRIAM rouses\nherself as her father enters with satchel. He\norders her to take her hat and coat which she had\nbrought in from the porch, during scene #92 - .\nShe wearily puts on her hat and coat. LEE leads\nthe way out and she exits.
s1229l11259	14	-9-\n\nScene -35  EXTERIOR.  (BACK INTO #30)  BRETT asks whether he may walk\nwith MIRIAM and she readily consents and they go.  She is all a-quiver over this adventure for she\nfeels that here at last is her Prince Charming.  He brings an atmosphere to her of the great outside\nworld, of the domain of wonderful things and of\nromance from which her narrow, provincial life,\nhas barred her.\nFADE\n\nScene -36  EXTERIOR.  ROADWAY in Millborough.  BRETT bidding goodbye to\nMIRIAM.  It is seen that in their brief acquaintance-\nship there has already arisen a certain degree of\nintimacy.  He asks her to call upon him at his fur-\nnished room in the village, feeling that he\ncan take advantage of her inexperience.  She re-\nfuses at first, but his arguments finally prevail\nand she reluctantly says -- "YES" -- she will be\nthere.  The kids, who have stood some distance from\nthem, come up to say goodbye.  The girl curtseys\nin a fine old-fashioned manner, and the boy makes a\nmilitary salute.\n\n"Don't forget to be there, sure."\nsays BRETT in parting.\n"I will be there"--MIRIAM assures him.\n\nSUB-TITLE:  AND MIRIAM KEPT HER PROMISE.\n\nScene -37  INTERIOR.  BRETT'S BEDROOM.  Decorated with Indian war-\nbonnet, Navajo blankets, tomahawks, and Mexican\nsombrore.  BRETT smoking, looks at watch.  Hears\nCartridge belt and\nsix-shooter\nknock on door and opens it.  MIRIAM shyly, reluct-\nantly enters.  BRETT is polite and circumspect.\nHe is reassuring her.  She looks around at his\ndecorations and expresses curious delight.\n\nScene -38  INTERIOR.  (BACK INTO #37)  Another angle of the room.\nMIRIAM closely inspecting blanket on wall.  Then,\nraises her glance to cartridge belt, and holstered\ngun.\n\nScene -39  INTERIOR.  CLOSE-UP - of the GUN - IN #37.
s1229l11259	37	-32-\n\nScene -179 INTERIOR. LEE SITTING ROOM. SAME AS #2. LEE and BARBARA sitting on either side of the table. The old lady has her sewing but has paused to speak about MIRIAM. Has LEE ever received any word from her. NO! Well, he is to blame-. He has cruelly treated the girl, where he should have showed more heart. He should not have ruled with a hand of iron, then she probably would not have ran away with the first good looking man who treated her human. The KIDS come in, dressed for bed. LEE permits them to kiss him and Aunt BARBARA leads them off. Old LEE sits with his head bowed in thought and his hand is on the open Bible beside him.\n\nSUB-TITLE: BURKE ACCEPTS AN INVITATION TO CALL.\n\nScene -180 INTERIOR. MIRIAM'S BOUDOIR. (SAME AS #158) BURKE is just being shown in by the maid. He gallantly kisses her hand and then presents her with a jewel case. MIRIAM opens it and is in rapture at the sight of a serpent crown - 3 diamonds. Holds it from her in ecstasy.\n\nScene -181 INTERIOR. CLOSE-UP - of MIRIAM'S HAND - holding the jewel.\n\nScene -182 INTERIOR. (BACK INTO #180) MIRIAM places the crown on her head, and surveys herself at all angles in the mirror. BURKE watches her pleased and amused. Compliments her, etc.\n\nScene -183 INTERIOR. ROOM IN HAZEL'S APARTMENT. BRETT is about to leave. He has his arm about her, talking. Embraces her and starts toward door. Stops, reaches in his pocket. She holds up her hand to stay him, speaking. She goes to table, gets a cigarette, places it in his mouth, and lights it. He takes puff. They both go into a passionate "clutch" at the door and he exits. HAZEL turns to camera and shows that she is sure of him.
s1229l11259	33	-28-\n\nScene -153 INTERIOR. (BACK INTO #148) Wine has enlivened the BRETT party, which has had several additions.\n\nSpoken title; "Who's the new chicken?"\n\n(BACK INTO SCENE) A tipsy diner comes to table, puts his arm around BRETT'S neck and whispers, looking toward MIRIAM.\n\nSpoken title; "My wife!"\n\n(BACK INTO SCENE) When BRETT makes reply to the rounder, the latter takes the floor, and holding his hand aloft, shouts:\n\nSpoken title; "All hail the bride!"\n\n(BACK INTO SCENE) Rounder still making his newly-wed ballyhoo. Couples arise from tables, and, shouting felicitations, raise their glasses.\n\nScene -154 INTERIOR. CLOSE-UP - of MIRIAM - IN #153 . Eyes bright, face animated, and moved by the carnival spirit. Rico is falling about her head.\n\nScene -155/157\n\nSUB-TITLE: AFTER A YEAR.\n\nINTERIOR. FADE IN --- CLOSE-UP - of MIRIAM - in daringly decollette evening gown, cut to the waist. Back view on discovery. Extends arms, slowly turns as though to give some one a thorough view of the creation, and, so comes facing toward camera. Front of the gown the limit in daring. She wears a profusion of jewels in her hair, on her fingers and her arms. Her neck is unadorned.
s1229l11259	30	-25-\n\nShe turns ar i slowly moves off.\n\nScene -141  INTERIOR.  Flash of LEE in sitting room by fireplace, a melancholy, brooding figure, in the light of the flames.\n\nScene -142  INTERIOR.  KIDDIES' BEDROOM.  CLOSE-UP - of the KIDS - kneeling in prayer.  There are tears on their cheeks and they are sending an earnest, childish supplication for MIRIAM.\n\nScene -143  EXTERIOR.  ROAD.  LONG SHOT.  MIRIAM comes into picture and walks up road.  IRIS OUT --- receding figure of MIRIAM.\n\nSUB-TITLE:  A NEW CHAPTER STAGED\nIN THE GREAT CITY.\n\nScene -144  INTERIOR.  "CHICAGO" SID STONE'S FLAT IN NEW BRETT and MIRIAM down stage.  He has his arms around her and is talking to her tenderly, and reassuringly.  She says to him ---\n\n"And now we will be married right away, won't we dear?"\n\nHe says - "YES".  He has the minister waiting.\n\nBusiness between BRETT and MIRIAM while STONE and his wife standing back discuss the value of MIRIAM as a splendid aid to their crooked schemes.  Her freshness, her youth, her inexperience and all add value to her as a valuable tool.  It is made evident that the STONES are jubilant over this accession to their gang.  During this scene the door opens and HAZEL comes on.  Both of the STONES, anticipating a scene when HAZEL sees BRETT with the country girl, immediately bar her away and begin to explain.  HAZEL throws a curt "howdydo" to BRETT and listens to the placating argument.
s1229l11259	2	THE SOUL OF SATAN\nA Photopl\nve Parts\n\nRANDOLPH LEWIS\nDirected by\nOTIS TURNER\nfor the\nFOX FILM CORPORATION.\nWilliam Fox..\nPresident....\n\nCopyrighted 1917.\nWilliam Fox.....
s1229l11259	34	Sub-title\n-29-\nHer Shred of Honor - that she is a loyal wife.\n\nScene -158 INTERIOR. BOUDOIR. MIRIAM in her evening gown being inspected by her maid, who advances to give finishing touches to the toilette. Maid hands MIRIAM a rope of pearls which she puts about her neck. Maid gets wraps. BRETT enters. MIRIAM asks BRETT what he thinks of her new toilette. Still smoking, he answers briefly, and indifferently. Not at all interested. She is piqued. Maid helps MIRIAM with wraps. BRETT, with hat and coat on, looks at watch, and hurries them. MIRIAM and BRETT start.\n\nScene -159 INTERIOR. DANCE AND DINE RESORT. BRETT and MIRIAM and the STONES enter and take table. Stage fully dressed. Groups animated.\n\nSUB-TITLE: "BULLION" BURKE. A BIG MAN\nFROM THE BIG BEST.\n\nScene -160 INTERIOR. SECTION OF THE LOBBY - of the restaurant - affording a view of the main room. Enter BURKE. In evening dress, smoking cigar and meditatively pulling off his gloves. Looks into the dining room and turns without showing interest. A very unemotional sort of man. Walks off.\n\nScene -161 INTERIOR. (BACK INTO #159) Head waiter obsequiously shows BURKE to table. Place is now filled, and there is considerable motion.\n\nScene -162 INTERIOR. CLOSE-UP - of cabaret singer - IN #159 - singing coquettish song.\n\nScene -163 INTERIOR. (OUT INTO FULL SET #159) showing singer descending from the stage and start singing among the tables. Business as though the singer were asking someone to kiss her, extending her arms in supplication, ad lib. Works down to BURKE. He being alone, she, therefore, puts more emphasis in her work. BURKE smokes as though unconscious of her presence. General attention of the room directed to BURKE'S table.
s1229l11259	1	L 11, 259
s1229l11259	48	-43-\n\nMIRIAM approaches BRETT, who is coolly smoking, and, extending her hand with the ring, asks him to deny what HAZEL has said.\n\nScene -234 INTERIOR. CLOSE-UP - of MIRIAM - IN #233 - asking BRETT about their marriage. Her face is tragic in its calm. Was the marriage a fraud?\n\nScene -235 INTERIOR. CLOSE-UP - of HAZEL - IN #233 - Cool, sneering and knowing that the blow is about to fall on MIRIAM.\n\nScene -236 INTERIOR. CLOSE-UP - of BRETT - IN #233 - He hesitates.\n\nScene -237 INTERIOR. CLOSE-UP - of MIRIAM - IN #233 - She says --\n"Answer me, you coward!"\n\nScene -238 INTERIOR. CLOSE-UP - of BRETT - IN #233 - stung by the speech, he savagely says -\n"YES!"\n\nScene -239 INTERIOR. (BACK INTO #233) MIRIAM passionately denounces him. "Coward! Coward! Not fit to live. And, yet you call yourself a man." HAZEL interposes, but MIRIAM, in the strength of her indignation, hurries her to one side and turns to heap her denunciation upon BRETT. He suddenly flames up and tells of the whole deception and taunts her with being only a romantic country fool. She was no good and now he intended to throw her out. Cut into the gutter! BURKE appears in the doorway at the beginning of BRETT'S speech, and, as he finishes, rushes at him and throttling him says he is not fit to live. As BRETT goes limp in his grasp, begging for mercy, the strong man hurries him contemptuously to the floor, where BRETT lies inert and panting. BURKE says --\n"You'll come now, won't you?"\nand placing a protecting arm about MIRIAM, starts to lead her off. HAZEL cries to BRETT and he raises himself up. Seeing BURKE and MIRIAM going and mad with cowardly rage, he springs to his feet and
s1229l11259	41	-36-\n\nScene -197 EXTERIOR. CABARET DINING PLACE. BURKE and MIRIAM, MR. and MRS. STONE and BRETT and HAZEL come on. Auto agents motion off for cabs. BRETT, who comes forward, suddenly shows signs of terror and cigarette drops from his mouth. Both MIRIAM and BURKE note it and follow the direction of his glance.\n\nScene -198 EXTERIOR. Slowly passing cab, only the window of which is shown. Framed in it is the silhouette of CALVERT -- THE SHADOW MAN.\n\nScene -199 EXTERIOR. CLOSE-UP - of MIRIAM and BURKE - IN #197 - He narrowly studying her expression. Her eyes widen; then close; face becomes tense and she turns to look at BRETT.\n\nScene -200 EXTERIOR. CLOSE-UP - of BRETT - IN #197 - expressing object fear, cowardice.\n\nScene -201 EXTERIOR. CLOSE-UP - of MIRIAM and BURKE - IN #197 - Her face shows a growing contempt. BURKE'S grim satisfaction that now, at last, BRETT is about to face merited retribution.\n\nScene -202 EXTERIOR. (BACK INTO #197) BRETT has regained his nerve and no one seems to have noticed his emotion save MIRIAM and BURKE. Machines come up and the party enters.\n\nSUB-TITLE: A REFUGE IN THE COUNTRY.\n\nScene -203 INTERIOR. LIVING ROOM OF VILLA. Upper and lower entrances at R. Large double window at C. back, giving out onto the veranda. Another porch window at about L. In this room BRETT has hung his trophies of the West --- Navajo blankets; tomahawks, and the cartridge belt and six-shooter. MIRIAM is throwing off her wraps and BRETT is taking a turn around the room, looking at the familiar objects, when the maid appears at the door and MIRIAM exits. BRETT lights a fresh cigarette.\nFADE
s1229l05191	2	MAY -4 1915\nTHE UNIVERSAL WEEKLY\n19\n© C.I.L. 5191\nAdventuress Marries Count to Rob Him\nO N May 9th the Universal will\nrelease under the Big U brand\n“The Master Rogues of\nEurope,” a three-reel melo-\ndrama staged in European\nsettings. The scenes in the\ndrama were filmed in Russia\nand England by a foreign company and\ndirector. The story of the play, in short,\nis as follows:\nOlga, an adventuress, receives a doped\ncigarette from her accomplice, Peter, to\nbe given to the Count Von Rade, a\nwealthy nobleman whom they are trying\nto entrap. Olga has previously written a\nletter to the count naming a rendezvous where she has agreed\nto meet him.\nA few moments later the Count arrives and picks up Olga\nin his automobile. They ride along the road for several minutes.\nOlga gives the Count a cigarette, the only one left in her case,\nand soon the latter falls unconscious. Olga takes the wheel\nfrom him and brings the auto back to where Peter is waiting.\nUnknown to either of the two conspirators, James Langtry,\nan English chemist,\nis watching them\nas they remove the\nCount from the car\nand rob him of all\nhe has upon him,\nincluding a large\nsum of money and\na pearl necklace.\nIn her hurry Olga\ndrops her fur cap.\nLangtry picks the\ncap up, hastens to\nthe Count’s assist-\nance and takes the\nstupefied nobleman\nto a hospital. There\nhe tells his story\nand the police are\nnotified.\nThe latter in-\nspect the neighbor-\nhood of the Alexis\nbridge where the\nrobbery occurred. The fur cap\nserves as a clue to the owner\nand from the maker of the cap\nthe police soon learn that only\nthree of the caps have been\nsold. The owners of all three\nfur caps are watched and sus-\npicion finally falls on Olga.\nThe police throw a cordon\naround her home and Peter and\nOlga, looking from a window,\nsee the officers waiting to seize\nthem when they leave. The con-\nspirators hide the jewels and money in a satchel and await\ndevelopments.\nThe police finally enter the house, prepared for a fight, and\nseize Olga. Peter climbs out of a window and clings to a\nwindow shutter while the officers are searching the apartment.\nAfter a short search the police find the satchel and jewels in a\ncabinet and an incriminating letter causes them to take Olga\nwith them to prison. Peter, after their departure, swings\nback into the deserted room, exhausted from his long suspen-\nsion from the window blind, several stories above the street.\nThe police continue to watch the house and Peter intercepts\nan old woman on the stairs, induces her to change clothes with\n“The Master Rogues of Europe,” a\nBig U three-reel drama staged in\nEngland and Russia, relates thrilling\nadventures of a pair of clever Conti-\nnental crooks who mulct their titled\nvictims, and attempt to murder those\nwho stand in their way. Scientist’s\ninvention saves him from death and\nfinally results in capture of crooks.\nReleased May 9.\nhim for a purse of gold, and then hurries\nfrom the house unrecognized. Notices\nhave been posted offering 500 roubles re-\nward for Peter’s apprehension. The cri-\nminal is described as follows :\n“Peter Bulban. Height, 5 ft. 11 ins.\nWeight, 175 pounds. Complexion, dark.\nNose, large and hooked. Chin, protrud-\ning.\nImperial Police Dept.”\nPeter reads the notice and at once steps\ninto a barber’s and disguises himself after\nhe has been cleanly shaved. The criminal\nthen goes to a restaurant connected with\na dive where he meets another friend\nfrom the underworld. The two read in a\nnewspaper of Olga Sopolska’s arrest and of her sentence to\npenal servitude for life in Siberia. Peter’s friend agrees to\ndress as a peasant and to assist Peter in rescuing Olga.\nOlga is taken\nalong a country\nroad together with\nother political of-\nfenders guarded by\na platoon of sol-\ndiers. Peter writes\na note reading as\nfollows: “Pretend\nthat you cannot\nwalk and I will do\nthe rest.” The note\nis rolled into a\ncigarette. Soon af-\nter Peter hires an\nautomobile and\ndrives it himself to\na point in the road\nwhere the soldiers\nand their prisoners must\npass.\nHe pretends to have a\nblowout and when the sol-\ndiers pass along, Peter en-\ngages an officer accompany-\ning Olga in conversation. He\noffers the soldier a cigarette\nand accidentally drops it.\nWhen the soldier stoops to\npick it up Peter slips the\nnote he has written to Olga.\nOlga soon after pretends\nthat she is too weary to walk\nand the officer asks Peter to give her\na lift in his car.\nNoon approaches and the soldiers\nstop to rest. Peter buys all the sol-\ndiers wine and food while his accom-\nplice, disguised as a peasant, removes\nthe bullets from their guns. While\nthey are eating and the officer is in-\nside a nearby roadhouse, the peasant\nquietly gets in the car with Olga and\nPeter and all three suddenly drive off. The soldiers, leaping\nto their feet, attempt to fire upon them but find that the bullets\nhave been removed from their guns.\nAfter their escape Olga and Peter repair to an English\nwatering resort where Olga tries to entrap Count Feauchon, a\nFrench nobleman, into marrying her. Dr. Langtry, the nephew\nof Count Feauchon, notifies the police and the latter return to\nCount Feauchon’s home and catch Olga and Peter red-handed\nas they are about to rifle the Count’s cabinet containing his\njewels and valuables. The pair are arrested and this time\nthey do not escape. Langtry remembers the pair as the ones\nwho robbed Count Von Rade and obtains their conviction.\nScenes from the continental feature release, “The Master\nRogues of Europe.”
s1229l05191	3	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l05191	1	< 5/91
s1229l03312	1	L 3312
s1229l03312	2	© C.I.L. 3312\nTHE AGELESS SEX\nOWNED AND PRODUCED BY\nTHE VITAGRAPH COMPANY OF AMERICA.\nDIRECTOR: CAPTAIN HARRY LAMBART\nAUTHOR: JOHN FRANCIS\nHe thinks his wife is all false and eighty-two years old.\nThis is the astonishing hallucination a young husband has.\nHe discovers that her beauty is entirely made up of artificial\narticles. Wigs, false teeth, "form plumpers" etc. He awakes\nsobbing pitifully. It is a comical affair when he discovers\nit was all a dream.\n*****
s1229l03312	3	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l04677	3	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l04677	2	©CIL 4677 √\nHIS DESPERATE DEED\n(Synopsis)\n\nBurleigh, a rancher, is informed that the inspectors\nhave condemned his cattle. His sister, Grace, rides out to meet\nher lover, Grant, a neighboring rancher. Grant is joyous because\nthe inspectors have passed his cattle. Burleigh and his foreman,\nwho hates Grant for having won Grace's love, plan to steal their\nneighbor's cattle. They are successful in driving them off under\ncover of night. Grant is alarmed by the sudden illness of his\nmother, and, rushing into his barn to saddle his horse so that he\nmay fetch the doctor, he discovers what has happened. "They might\nhave left me my horse!" he thinks bitterly, as he plods along the\ntrail. Suddenly he hears hoofbeats; the mail carrier comes loping\nalong the gulch. With desperate intent, Grant whips out his gun\nand, covering the man, orders him to halt and dismount. The order\nobeyed, he takes the horse and sets out at a gallop back along the\ntrail toward the doctor's house. The mail carrier, walking back\nto the nearest post office to give the alarm, is overtaken by a\ncowboy who gives him a lift. When he reaches the post office he\nfinds the postmaster and citizens very much puzzled over their own\nmail sacks, recently dispatched, which have been found on the plat-\nform. Grant has thrown them down as he galloped by. A posse is\norganized to capture the offender. Grant meanwhile has fetched\nthe doctor, who pronounces his mother out of danger. Grace,\nhearing her brother and the foreman returning from their night\nriding, discovers what they have been up to, and rides to Grant's\nhouse. It is she who, finding the sick woman alone with an inex-\nperienced halfbreed girl, has nursed her out of danger before the\ndoctor arrives. When the posse comes thundering into the house and\narrests Grant, she tells a story which supports his claim of innocent\nintent in taking the mail carrier's horse. The sheriff is satisfied\nthat no harm was meant or has been done. Just then Burleigh,\nmissing his sister and suspecting where she is, rides up and accuses\nGrant of luring the girl away. Hot words follow, and finally\nBurleigh is silenced by his sister, who tells what she knows and\nadvises him to return Grant's cattle.
s1229l04677	1	<4677
s1229l05188	3	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l05188	1	25/88
s1229l05188	2	© CIL 5188 Y\nBARTERED LIVES.\nPhotodrama in Four Parts-----One of the George Kleine Attractions.\n........................................................................\nHesperia, an artists model, and her twin sister, Pierrette, a\nsinger, so closely resemble each other that they cannot be told apart\neven by their most intimate friends, and are able to impersonate each\nother at will. One morning Hesperia awakens with a bad headache, and\nhaving an engagement to pose for a young painter that day, asks her\nsister to take her place. Pierrette consents, and at the artists studio\nmeets a millionaire through whose influence with the managers she obtains\na position upon the stage. She soon becomes a famous opera singer and\nsometime later goes abroad, leaving her sister Hesperia at home alone.\nPierrette, carried away by her love for money, becomes engaged\nto a wealthy banker whom she does not love and whom she does not scruple\nto deceive. He soon learns that her love for him is only feigned and\nin desperation attempts suicide. He succeeds only in severely wounding\nhimself, but his method of attempting his own life is such as to point\nto attempt at murder, and he allows it to be thought that he was attacked\nby someone else, hoping to obtain revenge upon Pierrette by having her\naccused of the crime.\nWhile the banker is in the hospital, Pierrette, panic-stricken,\nflees the country, but not before writing to her sister Hesperia, telling\nher that she is going away and that she wants her to come and live in\nher mansion during her absence. Hesperia arrives, and being mistaken by\nsome of Pierrette's friends for the singer herself, decides to keep up\nthe deception in order to enjoy the luxuries that go with the life of a\npopular prima donna. She even signs a contract to sing in a new opera\nand in the actual presentation of the piece scores a great success.\nThe banker, now fully recovered, visits Hesperia and, never suspecting that she is not Pierrette, again presses his suit with ardor.\nWhen the girl refuses to have anything to do with him, he again plans\nrevenge and uses the incident of the shooting to have her indicted for\nattempt at murder. Her story that she is not Pierrette, but her twin\nsister Hesperia, is not believed, and the mesh of circumstantial evidence\nwound by the banker's unscrupulous detectives makes her acquittal of the\ncharge practically an impossibility.\nPierrette, living under cover, has not the courage to come forward\nand announce her identity, but at last, when she sees that her sister is\nalmost certain to be sent to prison, writes to the officers of the court,\ntelling them the truth. She plans to take her own life before the\nofficers arrive at her hotel, but the hand of destiny intervenes. A\nterrific storm breaks over the city, and Pierrette, when she goes to\nthe window to draw the shade, is struck dead by a bolt of lightning.\n........................................................................\nMAY -3 1915
s1229l17130	3	SPECIAL REPORT\nof\nThe National Board of Review of Motion Pictures\n70 FIFTH AVENUE\nNEW YORK CITY\n\nTo Associated First National Pictures, Inc.\n\nGentlemen:\n\nWe wish to advise you that the majority comment on your photoplay\n"ONE ARABIAN NIGHT"\nreviewed by The National Board of Review on July 22, 1921\nwas as follows:\n\nENTERTAINMENT VALUE UNUSUAL EDUCATIONAL VALUE EXCELLENT AS ARTISTRY\n\nARTISTIC VALUE: Dramatic interest of story UNUSUAL Coherence of\nnarrative EXCELLENT Acting EXCEPTIONAL Photography EFFECTIVE\nTechnical handling DEFT AND SURE "Costuming (if period pro-\nduction) EFFECTIVE Atmospheric quality—Scenic setting EXCEPTIONALLY CONVINCING\nHistorical value (if period production) UNUSUALLY INTERESTING FOR ITS TREATMENT\nOF THE ROMANCE PERIOD OF ORIENTAL FICTION.\n\nGENERAL COMMENT: THIS VIVID, SWIFT-MOVING PICTURE IS THE IER OF ORIENTAL DRAMAS\nON THE SCREEN. IT HAS THE TRUE ATMOSPHERE OF AN ARABIAN NIGHTS' TALE AND\nMUST RANK AS ONE OF THE EXCEPTIONAL PHOTOPLAYS OF THE YEAR. IT HAS BOTH\nDRAMATIC INTENSITY AND COMIC RELIEF OF AN UNUSUAL ORDER. THE ACTING OF\nFOLA NEGRI MAY BE SAID TO BE THE FINEST AND MOST CONVINCING OF HER CAREER\nBEFORE THE AMERICAN PUBLIC AND THE SUPPORTING CAST IS ONE OF GREAT ABILITY.\n\nThe critics of the\npublic. They bring\nand liberty of re-\nsented through\nsame time soci-\nThe National B\nality, and even\ndiligently for\nThough it is a v\nthe crystallization\nreflect through it\nthe country.\n\nENTERTAIN\nEDUCATIONAL\npresentation and interpretation of\nent classes of society past and present.\nMORAL EFFECT—This applies\nARTISTIC VALUE—This to\nartistic out-door scenes and ac-\ncess of incongruous elem\n\nPresented to the\nauthority of speech\nto ideas pre-\nc. At the\n\nOF MOTION
s1229l17130	5	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l17130	1	OCT 25 1921\n\n©CIL 17130\nCarter De Haven\npresents\nMr. and Mrs. Carter De Haven\nin\n"My Lady Friends"  nytray\nFrom the stage play by Emile Nybray and Frank Mandel\nAdapted for the screen by Rex Taylor\nDirected by Lloyd Ingraham\nPhotographed by Barney McGill\n\nCAST\n\nJames Smith .............................Carter De Haven\nCatherino Smith .......................Mrs. Carter De Haven\nEdward Early ...........................Thomas G. Lingham\nLucillo Early ...........................Helen Raymond\nEva Johns ...............................Helen Lynch\nTom Trainer ............................Lincoln Stodman\nHilda .....................................May Wallace\nIsaacs ......................................\n\nNora ) Hazel Nowoll\nGwen ) Three Lady Friends ...........Clara Morris\nJulia ) Ruth Ashby\n\nSYNOPSIS\n\nJames Smith was possessed of a laudable desire to spend the millions he had\nacquired making Bibles, but Mrs. Smith still remembered the old days when they were\nstriving to make every penny count. James gave her a book of signed checks and\nurged her to go out and spend all she could, but without avail. She would darn sock\nfor him, in spite of the excellent example set her by Lucillo, the extravagant wife\nof the Smiths' friend and lawyer, Edward Early.\n\nOn business trips to various cities, James had been spending his money briskly\nwith ladies of a less economical turn than his wife. One day he was embarrassed\nby a letter from one of them telling him that she was coming to see him in his\nlittle bungalow at Atlantic City. A second letter bringing the same news from another\nfriend drove him to his wits' end, and he turned the matter over to Edward\nEarly, offering him a handsome bonus for helping him out. Edward foresaw complications\nfor himself, and began operations by sending a bouquet of flowers to his wife\nwhich disturbed her to the point of talking over her suspicions with Mrs. Smith.\nA perfumed epistle arrived for James during their conference and made two suspicious\nwives instead of one. Mrs. Smith promptly called off the trip to Atlantic City\nmuch to the disappointment of her orphaned niece, Eva Johns. To console Eva, James\npromised to take her to the beach and gave her money to buy a bathing suit.\n\nJames barely reached Atlantic City when he ran into one lady friend, who\nsaid the lawyer had been to see her, but she had merely thought he was trying to\nbribe her to keep away. The two other ladies arrived during the day, each telling\nthe discreet maid that she was the future Mrs. Smith. James rushed the innocent\nEva back to the city, and tried his best to explain matters to each girl in turn.\nAs their rooms were separate they did not run into each other immediately. Meanwhile,\nMrs. Smith and Lucille, who had put a detective on the case, received his report\nof various ladies entering the house. Mrs. Smith promptly started for Atlantic City\nto investigate for herself, but finding no one in the rooms she entered,\nreturned to tell Lucille that it was her Edward and not James who had been going with\nthe ladies. The two wives came back to Atlantic City together, and a general explanation\nfinally reconciled them all, though not before Mrs. Smith made up her mind\nto start out with her book of signed checks and outspend the lady friends.\n\nCopyrighted by Carter De Haven\nGreens
s1229l17130	4	REQUEST FOR RETURN OF COPYRIGHT DEPOSITS\nOCT 25 1921\n\nDated at Washington D C.\nOct 25, 1921\n\nRegister of Copyrights,\nLibrary of Congress,\nWashington, D. C.\n\nDear Sir:\n\nThe undersigned claimant of copyright in the work herein named,\ndeposited in the Copyright Office and duly registered for copyright pro-\ntection, requests the return to him under the provisions of sections 59 and\n60 of the Act of March 4, 1909, of one or both of the deposited copies of the\n2 Prints Each entitled\n"My Lady Friends" & "Bits of Life"\ndeposited in the Copyright Office on October 25-1921 and registered\nunder Class XXc., No. 17130-17129\n\nIf this request can be granted you are asked and authorized to send\nthe said copy or copies to me at the following address:\nor\nto\nat\n\nSigned Associated First Nat Pictures Inc.\n(Claimant of Copyright)\n\n24 Copies Returned\nOCT 26 1921\nBk. D\n\nReceived\nOct 26/21\n\n☆ O.K. - F.G.P.\nOCT 26 1921
s1229l17130	2	ASSOCIATED FIRST NATIONAL PICTURES\nOF\nWASHINGTON, D. C., INC.\n6TH FLOOR. MATHER BUILDING\n916 G ST., N. W.\nPHONE MAIN 176\n\nFIRST\nNATIONAL\nANNIVERSARY\nWEEK-FEB-18-25\n\nOCT 25 1921\n\nTITLE PAGE.\n\n©CIL 17130C\n"MY LADY FRIENDS"\nA PHATOPLAY in---6 Reels.\nDirected by Lloyd Ingraham.\nAdapted by Rex Taylor.\nAuthor of Photoplay Carter De Haven, U S A.\n\nThere'll be a Franchise everywhere
s1229l11989	3	touch with the girl. She, now knowing his real name searches for him in\nvain.\nShortly after this, Stedman, who has grown a professional beard\nand undergone all the changes of prosperity is called in to operate\non Dorothy's aunt. He is constantly associated with Dorothy, and finds\nto his surprise, that she does not recognize him.\nRealizing that she fooled him in the slum days, he resolves to\ntake good natured advantage of his opportunity and fool her. As Dr.\nStedman, he makes love to her, Dorothy, strangely attracted by him, and\nwith the memory of the vanished Martin West dimmer in her mind, gives\nthe surgeon a hesitating acceptance.\nNow Stedman's former wife back from abroad, where her second\nhusband died, desires to remarry Stedman. She follows him to the\nhotel where Dorothy, her aunt, and the doctor are staying, and prepares\nto carry on the siege. Fearful that she may injure his affair with\nDorothy, Stedman tells her she must leave the hotel.\nUnfortunate he is seen emerging by Dorothy; who has noticed that\nStedman knows Mrs. Canfield.\nNaturally, the engagement is off, Dorothy, departing secretly\nfor New York and the slums again, leaves a note for Stedman; which is\nintercepted by Mrs. Canfield; who later shows it to Stedman, to con-\nvince him that Dorothy was playing with him all along.\nSince the note announces that Dorothy has gone back to look\nfor his other self--Martin West, it produces the opposite effect.\nStedman leaves for New York at once.\nAdopting his Martin West disguise, he returns to the boarding house\nwhere he meets Dorothy. He takes her at once--not giving--her a chance\nfor explanation--to City Hall; where, by arrangement with his friend the\nBoss--Now an alderman performing marriages in the chapel--he obtains a\nservice in which Christian names are conveniently numbled.\nIn their sitting room at the hotel, Dorothy is about to confess\nher identity when she sees a newspaper, flaming with the news of her\nmarriage to Dr. John Stedman, the well-known specialist.\nLooking at her husband with the eye of knowledge, she sees that\nit is so.\nShe has married both her lovers in one!
s1229l11989	1	L 11/989
s1229l11989	2	JAN 26 1918\n\n© C.I.L. 11989\n\n"THE OTHER MAN"\n\nBy\nXXXXXX; Rex Taylor & Irma Whelpley Taylor;\nPicturized by Fred Buckley.\nFive Reel Drama\n\nCopyright by; The Vitagraph Company of America\n\nProduced by; The Greater Vitagraph.\n\nFinding the worldly wife he adored in intrigue with a man of\nhis acquaintance, John Stedman compels a divorce and remarriage,\nabandons his practice as a surgeon in Philadelphia, and disappears,\nin search of forgetfulness. The search ends at a lamp-post in the\nslums of New York; Stedman penniless, the remains of his fortune a\ngrip and the unreasonable clothes he wears and the lamp post sole\npivot of an unsteady world.\n\nA saloon fight arouses him from torpor. By saving the life\nof a valuable tough, he gains the good will of the political boss of\nthe ward; who retains Stedman--under the name of Martin West--as his\nprivate doctor, always to be on hand in case of the hourly expected\nshooting. Regular practice, under a name which does not appear in\nthe State medical license records is, of course, impossible.\n\nThe boss helps West in several ways; notably by helping him\nto overcome his post-divorce craving for drink.\n\nBut his influence is eclipsed when there arrives in the\nboarding house where West stays a new servant; who is really an\nheiress, Dorothy Harmon in the slums on a bet. She is to make her way\nthere for two months. West becomes very friendly with her; and by the\nend of the appointed period, is in love with her; and she with him,\nthought he gives no sign. She has restored his ambition, however and\none night, he tells her his story--all but his name. He is interrupted\nby news that the Boss has been shot.\n\nFinding immediate operation necessary, he takes his reputation\nin his hands, improvises with the scalpel, and invents a new operation,\nwhich saves the boss 'life.\n\nReturning to Dorothy--too excited to take up the thread of\nrevelation where it broke--he tells her of this operation, and laments\nthat he has not the ten thousand dollars that would enable him to\nregain his practice, introduce the operation, and gain his former\nposition.\n\nDorothy meditated. Ten thousand is the stake in the bet she has\nwon. She makes arrangements for its anonymous transfer to West, in the\nform of a peculiar charity. This is accomplished; and West goes to\nPhiladelphia rejoicing; with a promise to return for "Deirdre Jones"---\nto whom he has not yet proposed--when he has made good again.\n\nDorothy, of course, leaves the slums next day, and in her own\nhome awaits news from West who was to write to her at the boarding house.\nShe does not intend to appear in her true character until he returns.\nNo news from him arrives. This is because the keeper of the boarding\nhouse has lost Dorothy's address. The letters in which West, now\nStedman again, and more successful than ever, tells her of his progress,\npile up unopened on a kitchen shelf. At the end of three years, when\nStedman comes to New York to Claim Deirdre and pay back the ten\nthousand dollars, she is out of town, with her aunt. Stedman is dis-\nmayed to find that, with the loss of the address, he has lost all\n\nDirector; Paul Scardon
s1229l11989	4	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l08234	1	L 8234
s1229l08234	2	“A FIGHT FOR LOVE.”\nBison Two-Reel Underworld Drama—\nReleased May 15.\nCIL 8234\nStory by W. B. Pearson.\nScenario and Production by J. Jaccard.\nMarisico Napoli........G. Raymond Nye\nGracia ...................Roberta Wilson\nChief Basista...........J. De Rosa\nPola.....................Hector V. Sarno\nThis is an authoritative story of the\nCamorra based on facts. Two more out-\nrages take place and the lieutenant of the\nItalian squad is notified to act at once, or\nhis station will be the target of the news-\npapers. He gets two detectives and to-\ngether they fix a frame-up on Marsico\nNapoli, a right-hand man of the Camorra\nChief, Basista, who, being a shrewd man,\nhas so far been able to elude the police.\nThey “plant” him by slipping a gun in his\npocket, which offense carries a five-year\nterm in New York City. He resists; they\nbeat him up, take him to the station and\nput him through an eighteen-hour third\ndegree to try and make him “squeal” on\nthe rest. He stands firm, and is helped\nto do so by the appearance of Gracia,\nthe Lieutenant’s daughter.\nThe Camorra hold a meeting and plan\nthe best how to get Marsico free. They\ndecide to grab Gracia, which they proceed\nto do, and send the Lieutenant a note\nreading: “We got the girl. If Marsico\ndon’t go free she will suffer the conse-\nquences.” Therefore the father’s hands\nare tied in fear that the Camorra will\nfulfill their threat.\nMarsico is in the hospital (from the\nbeating he has received) and reads of\nGracia being missing. As she came to\nhis aid in the third degree and brought\nhim flowers in the hospital, Marsico de-\ncides to rescue her. He plans carefully\nand makes his escape.\nMarsico goes to the Camorra Lodge,\npresents himself and demands the release\nof Gracia, but in the meantime the Chief,\nBasista, has fallen in love with Gracia\nand refuses to turn her loose. The two\nfight with stilettos, in accordance with\nthe lodge rules. Marsico wins, goes after\nGracia, and as he brings her out, the\nmeeting has divided and a battle royal is\nfought. Gracia and Marsico get into the\nupper hall, and the fight swings with them\nonto a two-story building. A very thrill-\ning fight takes place, the Marsico faction\nwinning.\nMarsico returns Gracia to the Lieuten-\nant, and of course is placed under arrest,\nthe Lieutenant telling him that he will do\neverything in his power to get a pardon\nfor him. Marsico curses him and his par-\ndon, and says he will settle with him\nwhen he gets out, if the Camorra spares\nhis life.
s1229l08234	3	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l16965	4	- 3 -\n\nin a Siberian prison.\n\nIt happens that Helene and Lord Hawcastle, posing as man\nand wife, are living at the Hotel Regina Margherita in Sorrento. Ethel and Horace,\nknown as wealthy young Americans, are living at the same Hotel. Helene worms\nher way into Ethel's confidence and Lord Hawcastle wires his son the Hon. Almaric\nto come to Sorrento prepared to marry a wealthy American girl.\n\nThe Hon. Almaric arrives and meets Ethel and Horace on the\nterrace. Ethel seems a little too simple to suit him but after a few moments\nLord Hawcastle takes him aside and tells him that their depleted fortune must be\nincreased, and he must marry Ethel in a month.\n\nIn the meantime Helene is cleverly flattering Ethel, and\nimpressing upon her the fact that with her advantages she can marry into the best\nfamily of Europe.\n\nIvanoff is working in the mines of Siberia, with other\nconvicts. One day a crazed prisoner blows up the mine, when the smoke has cleared\naway Ivanoff finds that the walls have caved in and covered his companions,\nhe is the only one that is alive. A queer stroke of fate discloses an abandoned\nshaft, Ivanoff crawls out and escapes. He reaches the shelter of an old barn and\nfiles his iron chains, then confiscates an old suit of clothes and continues his\n"get away". He finds a rack of hay along the road and while the driver is watering\nhis horse Ivanoff crawls under the hay, and is driven towards the border.\n\nIn the meantime he has been missed and an order taken to\nthe guard house at the border to keep a sharp look-out for an escaped convict. The\nhay rack stops before the guard house, the driver is questioned and says he has not\nseen anyone. But on general principles the guards shoot into the hay as the rack\ndrives on. One of the shots hits Ivanoff's temple and the blood streams down his\nface. He has a difficult time cluding his hunters, and has to ask for food at the peasant's doors along the way.\n\nBack in the States Daniel has been making progress in
s1229l16965	6	- 5 -\n\nThey go out on the Terrace and are ushered to a table next to the\none occupied by Lord Hawcastle and his party. Horace is furious at the intrusion.\nBut Daniel introduces Ethel and Horace to the "Doc". The Duke's servant comes to\nto warn him that an escaped Russian convict is in the neighborhood, and he must\nbeware. The Duke leaves the table. Daniel is distressed that Horace is so eager\nto have Ethel become the Countess of Hawcastle, and, when the Hon. Almeric is in-\ntroduced, Daniel looks at his fragile dressed-up frame and says, "If they want\n$750,000 for that how much do they charge for a real man over here?" This remark\nwreaks what little spirit of congeniality existed before and Daniel finds himself\nalone. Ethel seems to have forgotten that they were ever engaged and Daniel is deep-\nly hurt. He goes on around to the Court and begins tinkering with the "Doc's" car.\n\nIn the meantime Ivanoff has been sighted, in a field, and a desperate\nchase ensues. He succeeds in dodging his followers and coming into the Court, he\ncrews in the rear of "Doc's" car, while Daniel is working on the front. Daniel feels\nthe jar when Ivanoff crews in and going around makes him get out. Ivanoff is desperate\nand his appeal for protection wins Daniel. He gives Ivanoff his duster, and a\nmonkey wrench and pushes him under the car, begging him, however, "not to unscrew\nanything" just as the officers come running up with their guns.\n\nBut a maid has seen Daniel give the man his coat and she hurries\nto tell Helena and Lord Hawcastle that Daniel is harboring the convict.\n\nWhen the officer questions Daniel he denies even having seen a\nconvict and says that the man under the car is the "Doc's" new chauffeur. The\n"Doc" happens to come along at this time, and a glance at Daniel explains the sit-\nuation. The "Doc" true to his pledge of friendship to Daniel, actually tells the\nofficer that the man is his chauffeur. Such is friendship! The officers leave to\ncontinue their search.\n\nLord Hawcastle comes to Daniel, with the Maid's story fresh in\nhis mind, and threatens to put both him and the "Doc" in prison for helping a convict\nescape unless he gives his consent for Ethel to marry his son. Daniel appreciates\nthe Doc's friendship.
s1229l16965	3	- 2 -\n\nout to sea. She has left him a photograph that he keeps, on his large office desk,\nand looks at with a great longing while she is away.\n\nOne day Adam Simpson is driving a fast horse hitched to a\nlight buckboard, when the horse becomes frightened and runs madly along a winding\nroad. Simpson is powerless to check him, a sudden turn twists the wheels from the\nlight wagon and the horse trots down the road dragging the harness after him, while\nSimpson is left behind in a pitiful heap. Some farm hands come along and carry him\nto his home. The doctor is sent for and Simpson asks for Daniel who quickly arrived\nand finds Simpson dying. With his last breath Simpson dictates a will to Daniel,\nmaking him guardian of Ethel and Horace until they shall become of age, at which time\nthey will inherit one and one half million dollars.\n\nEthel and Horace are in Sorrento when they receive word from\nDaniel announcing their father's death and the fact that Daniel is their guardian.\n\nIvanoff, a large sturdily built man with curly hair, is in the\nemploy of the Russian Government. He is sincerely devoted to his young wife Helena,\na tall slender woman, selfish and eager for wealth and social prominence. She knows\nthat her husband is stealing from the Government to aid a Revolutionary force and en-\ncourages as well as helps him. When the Earl of Newcastle and his foppish son the\nHon. Almeric St. Aubyn are announced Helena takes them into another room for tea, while\nIvanoff turns over some papers to two of the Revolutionaries. The maid understands\nher master's situation and is careful that Lord Newcastle does not see the two men.\n\nBut Helena plans a double theft. She knows that her husband\nhas money in his desk. She and Lord Newcastle watch through the door for an opportune\ntime. Helena is successful in making her husband believe that she loves him, but she\nhelps Lord Newcastle steal both money and papers from his desk. The theft is discovered\nand blamed on Ivanoff. The maid put to torture testifies against him. Lord Newcastle\nsends officers who arrest Ivanoff while Lord Newcastle leaves the country with Ivanoff's\nwife. As the officers take Ivanoff away he finds his wife's handkerchief on his desk\nand knows that she has tricked and betrayed him. Ivanoff is sentenced to thirty years
s1229l16965	7	- 6 -\n\nthe fact that the Italian law will have no mercy in his case, but asks Lord\nHawcastle for a few hours' grace in which to consider the matter.\n\nDaniel is greatly worried and warns the "Doc" to beat\nit while the going's good". But to Daniel's surprise the "Doc" only laughs heartily\nand remains.\n\nLord Hawcastle tells his son, Ethel and Horace that he\nhas arranged matters so that the marriage can take place.\n\nIvanoff comes to Daniel's room and related his story.\nHe tells of his wife Helene having tricked him and then going away with a man called\nLord Hawcastle. Daniel is both surprised and relieved, because now he will be able\nto prove to Ethel that her wonderful family are not all that she imagines.\n\nSo Daniel sends Ethel a note asking her to meet him in\nthe Hotel parlors at ten in the evening. The Hon. Almeric is with Ethel when she\nreceives the note, he reads over her shoulder and reports to his father.\n\nThus it is that when Ethel goes to the parlors to meet\nDaniel, Lord Hawcastle is outside summoning a group of officers. Daniel has Ivanoff\ntell Ethel his story, which is interrupted by the entrance of Lord Hawcastle, his\nson and Helene.\n\nThere haughty air is broken down when they recognise\nIvanoff. Helene cowers beside a great chair as Ivanoff comes toward her. His big\nhands circle her throat and she is saved from being strangled by Daniel, who pulls\nIvanoff away. Lord Hawcastle summons the officers and orders Ivanoff's arrest.\nBut at this moment the "Doc" majestically walks in and changes the situation by\nannouncing that he is "The Grand Duke Vasilii Vasilivitch of Russia". He releases\nIvanoff, and gives him his freedom. Helene and Lord Hawcastle leave in great haste\nand degradation, and Daniel feels that the exit of Ethel's great European family\nis a good riddance. On the other hand he cordially invites the Grand Duke "to make\nhim a visit if he ever comes to Kolokomo."
s1229l16965	5	- 4 -\n\nhis law office. His ability has been recognized, and a committee is in his office\nasking him to run for Congress when a letter arrives from Horace with the surprising news that Ethel is to marry into the Nobility, and for Daniel to send "cash",\nas the dowry has been arranged at $750,000. Daniel is stunned. His dreams of\nrunning for Congress are dismissed, and he cables Ethel and Horace that he is on\nhis way over to see them.\n\nThe Grand Duke Vasilii Vasilievitch, of Russia, is burdened\nwith his duties and taking his trusted body servant with him he comes to Sorrento,\nincognito, for a rest.\n\nOne day on the streets of Sorrento his machine balks, and\nthe Grand Duke hails a passing donkey cart. The little Italian driver hitched his\ndonkey to the heavy machine, but the weight is too great for the little animal and\nhe balks too. Then the driver unmercifully beats his donkey.\n\nAbout this same time Daniel arrives in Sorrento. As he\nwalks along the street in his linen duster he is recognized as an American and is\nfollowed by beggars, flower girls, and curious people. Daniel sees the crowd around\nthe donkey. He rushes over and compels the driver to stop using his whip. Then\nwhen he realizes what they are trying to have the little animal do, he harnesses\nhimself to the machine, and walking beside the donkey pulls the car after him. The\npeople cheer, and the Grand Duke is delighted with Daniel. Daniel pulls the car\ninto the Court of the Hotel Regina Egherit. A maid sees the strange spectacle and\ngoing into the garden tells Helene, Lord Howcastle, the Hon. Almeric, Ethel and\nHorace, who are having Tea. They all come out to the Court and laugh at the man\nwho is doing this queer thing. Then he turns and Ethel and Horace recognize Daniel.\nThey both feel that to claim him as a friend will ruin their standing with the "English\nFamily" so they ignore him and go away. The happy expectation dies from Daniel's\nface, but the Duke claims his hand and friendship. He introduces himself as a\nRussian doctor with an unpronounceable name. Daniel takes his hand and says that he\nwill just call him plain "Doc."
s1229l16965	2	Play in four acts.\n\nSynopses made from picture\nBy Allie Lowe\nAugust 51-1921\n\nSEP 16 1921\n\n"THE MAN FROM HOME"\n\nJesse L. Lasky\n\npresents\n\nCharles Richmond\nin\nTHE MAN FROM HOME\nby\n\nBeeth Tarkington\nand\nHarry & Lean Wilson\nCecil B. De Mille\nDirector General\n\nDaniel Veorese Pike is a promising young attorney in Kokomo, Ind.\nHe has a keen sense of humor, and whatever he undertakes he succeeds in accomplishing. His greatest interest in life, however, is Ethel Granger Simpson, the sweet\nand attractive young daughter of Adam Simpson, a fabulously wealthy old white haired\ngentleman, whose love is divided between Ethel and his son Horace.\n\nThe Simpsons live in a rural district in the States, so rural in\nfact, that when Ethel runs across the fields to meet Daniel she wears a large sun\nhat that ties under her chin. Daniel always so happy to see Ethel that he will not\nheed her half hearted entreaty to refrain from a caress, although he respects her\nmodesty enough to shield her from the passerby on the road, with his hat when he ex-\nacts a kiss. Daniel and Ethel go to her father's study and ask that gentleman for\nhis daughter's hand. Ethel is shyly happy and perches herself on the arm of her\nDad's big chair while Daniel asks the great question. But Adam Simpson puts a dam-\nper on their youthful hopes of marriage with the announcement that he is sending\nEthel and Horace abroad for a period of three years, but at the end of that time\nEthel may marry.\n\nDaniel stands on a bluff and watches the steamer take Ethel\n\n68691 J10©
s1229l16965	9	LAW OFFICES\nFULTON BRYLAWSKI\nJENIFER BUILDING\nWASHINGTON, D. C.\nTELEPHONES MAIN 685-088\n\nRegister of Copyrights,\nLibrary of Congress,\nWashington, D. C.\n34721 SEP16'21\n\nI herewith respectfully request the return of the following named motion picture films deposited by me for registration of copyright in the name of\nJesse L. Lasky Feature Play Co. Inc.\n\nTHE MAN FROM HOME (5 reels)\nTHE CALL OF THE NORTH (5 reels)\n\nRespectfully,\nFULTON BRYLAWSKI.\n\nThe Jesse L. Lasky Feature Play Co. Inc. hereby acknowledges the receipt of two copies each of the motion picture films deposited and registered in the Copyright Office as follows:\n\nTitle                 Date of Deposit      Registration\nTHE MAN FROM HOME    9/16/21               L: ©CIL 16965\nTHE CALL OF THE NORTH 9/16/21              L: ©CIL 16966\n\nCopies Returned\n20 SEP 24 1921\nBr. Delin\n\nThe return of the above copies was requested by the said company, by its agent and attorney, on the 16th day of September, 1921, and the said Fulton Brylawski for himself and as the duly authorized agent and attorney of the said company, hereby acknowledges the delivery to him of said copies and the receipt thereof.\nO.K.-B.F.T.\nDelin\n\n
s1229l16965	1	SEP 16 1921\n\n©CIL 16965\nTHE MAN FROM HOME\n\nPhotoplay in five reels\n\nFrom the celebrated play by\nBooth Tarkington and Harry Leon Wilson\n\nProduced by Cecil B. DeMille\n\nAuthor, Jesse L. Lasky Feature Play Co. Inc.\nof the U. S. as employer for hire.
s1229l16965	10	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l16965	8	- 7 -\n\nLater Ethel realises that Daniel is very dear to her, and\nhas saved her from a step that could only have ended in unhappiness. When Daniel\nfinds Ethel alone and understands that she loves him, nothing else matters.\n\nAnd Daniel is happy that she has chosen The Man From Home in\nplace of the title of Countess.
s1229m01626	2	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229m01626	1	. © CLM 1626 √ FORD EDUCATIONAL WEEKLY #207. JUN -4 1920\n\n1. "LITTLE COMRADES"\nProduced by Ford Motion Picture Laboratories\nReleased through GOLDWYN\nCopyrighted 1920 by Ford Motor Company of Delaware.\n\n2. Tender indoor flowers appear puny and colorless alongside their natural brothers\nof the open air, so --\n\n3. -- the lives of these unfortunate children are guarded and dealt with accordingly.\nHere the children who are anaemic, tubercularly inclined and sickly are given\nspecial attention.\n\n4. Each morning the nurse takes the temperature of every child.\n\n5. A close tab is kept on their weight.\n\n6. Once a week the doctor makes a careful examination.\n\n7. Three good meals are served daily, milk being used in plenty.\n\n8. The tooth brush aids greatly in health's protection.\n\n9. Bad teeth are cared for at once.\n\n10. The noon-day nap.\n\n11. Play time.\n\n12. A shower bath promotes vim and vigor.\n\n13. The wheel chair patients are given an industrial training; - here dolls' beds, waste\nbaskets, taborets, etc., are skillfully made.\n\n14. Binding a book and weaving a basket.\n\n15. The bling and seeing children study the same lessons. Letters made with raised dots\nare read rapidly. This is called the Braille system.\n\n16. The study room where problems are worked with slate and stylus.\n\n17. Typewriting and making reed baskets.\n\n18. The summer comes and vacation time.\n\n19. Here our little comrades continue on the road to recovery.\n\n20. With plenty of good things to eat and lots of rest.\n\n21. The beach also lends a hand.\n\n22. Freckles was his name.\n\n23. "And the King shall answer and say unto them, Verily I say unto you, Inasmuch as ye\nhave done it unto one of the least of these my brethren, ye have done it unto me"\nSt. Matthew 25:40
s1229l11303	3	THE RED ACE”\n\nMr. Jaccard was informed that every\nepisode of the serial should have at\nleast two punches, and, three, if pos-\nsible, and that the ending of each epi-\nsode, like a successful serial story in\na magazine, should come at the most\ninteresting point.\nMiss Walcamp was in New York\nat the same time, and did all of her\nshopping for the serial in the metrop-\nolis, sat for abundant photographs,\nand made a few appearances and\nspeeches in New York houses in con-\nnection with second and third runs\nof “Liberty.”\nWhen Mr. Jaccard and his star re-\nturned to the Coast, he had a thor-\nough and comprehensive idea of all\nthat the home office required to put\nover a serial properly, and every re-\nquirement has been skilfully and com-\npletely followed. Several episodes of\nthe serial are already in the factory,\nand every one of them ends in the\nmanner required, has more than the\nnumber of punches specified, contains\nan unusual amount of suspense, and\nis far superior in every way to the\noutline of the story, which Mr. Jac-\ncard read to the heads of departments\nin New York City. There is every\nprospect that “The Red Ace” will\nhang up the record among Uni-\nversal serials, and it will have to\nbe a tremendous winner to do\nthat.\nThere isn’t a more daring\nwoman on the screen to-day\nthan Marie Walcamp. She is\nfully entitled to the appella-\ntion, “the dare-devil of the\nscreen.” Mr. Jaccard has\nwritten “The Red Ace” in\nsuch a way as to give her\nunusual opportunity to\nperform feats of daring\nand stunts which require\nthe firmest of wills and\na resolution which will\nflinch at nothing. Jump-\ning from a racing automobile\nto the back platform of a\nswiftly moving train is easy\nfor Marie, and hanging by\none hand from a rope bridge\nover a chasm a hundred and\ntwenty-three feet deep, and\nfiring her revolver on an ad-\nversary with the other hand,\nlooks like a very easy matter\nas one sees it on the screen. A\ndive from a 60-foot rock into\nLost Lake is accomplished\nwith the grace of an Annette\nKellerman. Almost any horse\nis like a rocking-chair to\nMarie, but in “The Red Ace”\nshe has an opportunity for\nthe display of horsemanship\nwhich has never been offered\nto her before, and she takes\nfull advantage of it. Marie Wal-\ncamp is incomparable in “The Red\nAce.”\nThe advertising book on “The\nRed Ace” has already been written,\nand is off the press, ready for de-\nlivery to the exchanges. It con-\ntains the full and complete meth-\nods for advertising the serial, and\nputting it over to the best advan-\ntage in every kind of house. Any\nexhibitor can obtain this book by\nwriting to the nearest Universal\nexchange.\nHere is a brief idea of the story.\nThis synopsis does not attempt to\ntell the story completely, but gives\nonly the rough outline to show you\nthe different factors, places and sit-\nuations that enter into this serial.\nIn a moment’s notice you can vis-\nualize the romantic, adventurous\nand thrilling possibilities of “The\nRed Ace”:\nWhile Virginia Lee, daughter of\nan American mining man, is attend-\ning a fashionable bazaar given for\nthe benefit of the American Red\nCross, Doctor Hirtzman, of a for-\neign Secret Service, is smilingly\ntelling his associates that the “Black\nEagle” has sailed to the fatherland\nwith six hundred ounces of much\nneeded platinum. But the Doctor\ndoes not know that, while he is speak-\ning, American ships sink the\n“Black Eagle” and sink her.\nPatrick Kelly, travel worn and\nweary, forces himself into the bazaar\nand gives Virginia a letter from her\nbrother Richard, who is at the “Red\nAce” Mine, telling her that since\ntaking a contract to supply the gov-\nernment with platinum, every ship-\nment has been stolen—messengers\nkilled—and Virginia’s father has dis-\nappeared. Virginia, very much wor-\nried, makes a thrilling and suspense-\nsustaining race for the Canadian\ntrain.\nInspector Thornton, of the Royal\nNorthwest Mounted Police, receives\norders to arrest Virginia’s father and\nbrother on a charge of treason for\naiding and abetting the enemy. The\nInspector instructs Private Winthrop\nto carry out the orders.\nMeanwhile, Virginia’s brother is\nattacked by a mysterious shape, and\nis left for dead but survives just long\n(Continued on page 39)\n\nJacques Jaccard author and director.\n\nthe new Universal serial.\n\nhis announcement:\nTO (EXHIBITOR’S INITIALS)\nI HAVE SEEN YOUR AN-\nNOUNCEMENT AND THE\nTHREATS THEY CONTAINED.\nI AM NOT AFRAID.\nTO THE PUBLIC\nTWICE HAS (Exhibitor’s initials)\nDEMANDED THAT I ANSWER\nHIS QUESTION\n“WHO WAS THE OTHER MAN?”\nTO RAISE THE CLOUD OF SUS-\nPICION THAT THE ANNOUNCE-\nMENTS HAVE SPREAD OVER MY\nNAME I URGE YOU ALL TO AT-\nTEND THE\n(Name here) THEATRE\nTO-DAY SO THAT I MAY REVEAL\nTO YOU THE REAL SOLUTION\nMY MYSTERY
s1229l11303	2	AUG 28 1917\nShoofly Coal & Iron Co. - Chester, Pa.\n1\n\nTHE\nLURE\nOF THE\nCIRCUS\n\nCIL 11303\n\nS HOEING mules is all you’re fit\nfor, so get busy.” So spoke\nBud’s father, the village black-\nsmith, as his son was treating\nhim to the usual story of his extraor-\ndinary talents as an animal trainer.\n“Well, I’ll show you all some day,”\nmuttered Bud, and just that minute\nLilly, his sweetheart, rushed up with\na circus ad, looking for a girl to ride\nbareback and a man to learn lion tam-\ning. It looked like Providence, and\nBud dropped his work at once.\nBud and Lilly are employed, Bud\nwith the understanding that he is to\nstart taming the young lions first\nand thus get used to them. But the\nmen around the arena make fun of\nLilly in her riding outfit, and the\nhorse leaves her in the ring hanging\non the end of a pole. She soon loses\nmuch of her ardor for her new pro-\nfession. Bud also has his troubles,\nfor when he starts training some\ncubs, the mother lion gets away\nand comes after him and he\nclimbs wildly up the cage wall.\nThen Al, the trainer, comes to his\nrescue and chases the lions away,\nbut just for fun, lets them out\n(Continued on page 38)\n\n“THE LURE OF THE CIRCUS.”\n(Continued from page 18)\nagain and they run after Bud, pur-\nsuing him until he has climbed over a\nfence.\nMeanwhile, Bringley has dropped a\nplug of tobacco near Charlie, the ele-\nphant, who eats the plug. Then, in-\nfuriated with such treatment, Charlie\npulls his chain loose and makes his\nway to the office where Lilly is just\ntelling Bringley that she doesn’t want\nto ride horses any more. Charlie\nknocks the office building over; Lilly\nand Bringley are lost in the wreckage.\nLilly finally meets Bud outside\nthe arena, and together they return\nto the blacksmith shop.\n“I’ll train mules, pop,” says Bud,\nputting on his leather apron.\n“Well, I won’t say I told you so,”\nanswers the old man.\nmanufacture. Co.)
s1229l11303	1	L // 303
s1229l11303	4	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l00904	4	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l00904	3	-2-\n\nheart's hand and they go out together while old Mr. Stevens looks after them,\nsighs, and then slowly turns away.\n\nThere is something of the old kindly sentiment our fathers loved in this\nquiet little drama. It makes a splendid picture, and—one that well deserves\nsuccess.
s1229l00904	2	© C.I.L. 904 R\nSYNOPSIS\n#1364\nIn the Garden\nA drama by\nWilliam Brede\n\nJune 30, '13\n*JUL 5 1913\n\nOld Mr. Stevens finds a lover, at a dance, sulking because his sweetheart is kind to other men. To prevent two lives from being spoiled by mis-understanding, the old man tells the indignant swain the story of his own lost love.\n\nIn 1860, Stevens, a gallant young Southerner was deeply in love with a girl, Julia. One evening, at a dance, the charming Julia seemed to her jealous lover to be accepting too many attentions from the young beaux of the company. With a Southerner's characteristic impetuosity, Stevens bitterly reproached her for her fickleness, and turning on his heel left.\n\nThat very night, Stevens enlisted in a Confederate regiment. Next day, as the troops marched out of town, Julia stretched out her hands pleadingly to her death lover, but he ignored her and left her without even a smile or farewell.\n\n"Men must work while women weep". And so, while Stevens fought valiantly for the South, Julia sat at home and stared wet-eyes across and waited.\n\nWe are not all made of the stern stuff that can wait and wait without hope, and that was why Julia grew paler as the days went by, why her blue eyes became deep somber wells of sadness.\n\nAnd so it was that Stevens at last came home to find that he like a better man "threw a pearl away richer than all his tribe". For Julia wept no more. She was dead.\n\nAs the old man finishes his story, the young man's sweetheart appears, radiant and lovable in her youth and beauty. It appears that it is the same dance, and she has saved it for her lover.\n\nWith a hesitating look at the poor old man, the lover takes his sweet-
s1229l00904	1	L904
s1229l05617	2	UNIVERSAL—ONE—DEW\n“THEIR SECRET.”\nBig U Two-Reel Drama—Released\nJune 27.\nScenario by Leonora Dowlan.\nProduced by William C. Dowlan.\nCAST.\nBilly Lawrence……William C. Dowlan\nTobias Smith………Allan Forrest\nCarrots ……………Eugene Walsh\nDaisy Lawrence……Violet MacMillan\nMrs. Brooks………Lule Warrenton\nVera Lawton………Carmen Phillips\n“WANTED—Woman to take charge of\na baby. Apply Mrs. William Lawrence,\n34 University St.”\nThis “ad.” is answered by an elderly\nwoman, Mrs. Gray, who finds a young\nlady, Mrs. Daisy Lawrence. Mrs. Gray\ninquires as to the baby’s parentage, as\nDaisy looks very young to be its mother.\nDaisy introduces Billy Lawrence, her\nhusband, and volunteers the following ex-\nplanation as to why she wants a woman\nto care for baby: Daisy says her mother\n(Mrs. Brooks), wanted her to marry a\nyoung man (Tobias Smith), who owned\nthe adjoining farm, and who seemed to\nDaisy to prefer the village belle, Vera\nLawton. Before the marriage, Mrs.\nBrooks thinks it is best for Daisy to\ncomplete a university course and sends\nher to the city.\nAfter arriving at school, Daisy is neg-\nlected by the other girls on account of her\nlack of style and country-made clothes.\nBeing left to herself a great deal, Daisy\nstudies the girls very closely, and when\nalone imitates them. On one of these\noccasions Billy Lawrence is hidden in the\ntree above her. His loud laugh attracts\nher attention, and the acquaintance thus\nstarted, soon ripens into love, and the\nyoung couple are married.\nNow, Daisy explains to the elderly\nwoman, that as her school term is finished\nand she must go home, she wants some\none to take charge of her baby, until she\ncan explain everything to her mother.\nBilly, her husband, is to go on ahead,\nsecure work on her mother’s farm, if pos-\nsible, and gradually win her friendship.\nEverything is settled and Billy leaves\nfor the farm. Meantime, the mother,\nwishing her daughter to have company\non the journey, sends Tobias Smith to\nthe city for Daisy. Tobias, being of an\ninquisitive turn of mind, inquires at the\nregistrar’s office of the university as to\nthe progress made by Daisy while in the\nuniversity. The registrar, learning To-\nbias is a messenger from Daisy’s mother,\ngives him a report card. On looking at\nthis, Tobias finds Daisy has been absent\nfrom school for three months. Tobias\nkeeps his knowledge of this a secret from\nDaisy.\nOn their arrival at the farm, Tobias\nno longer has eyes for anyone but Daisy.\nVera, angered at this, flies into a great\nrage.\nTobias proposes to Daisy, watched from\nnearby places by Billy, Daisy’s husband,\nwho is working on the farm, and Vera.\nDaisy refuses Tobias. Indignant, he\nsays he will make Daisy explain why she\nis absent from school for three months\nand shows her the report card. Tobias\ncalls Daisy’s mother. Daisy tells her\nmother she is married and introduces\nBilly. Daisy’s mother, indignant, orders\nDaisy to leave home. Daisy sends a\ncountry boy to the village, telling him\nto get a baby from Mrs. Gray at the hotel\nand bring it to her.\nOn the arrival of the baby, it is placed\nin grandma’s arms. Grandma says,\n“I can’t send my baby’s baby away,” and\nthe young couple kneel, one on each side\nof the mother.
s1229l05617	3	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l05617	1	< S617
s1229l05370	1	〈S370〉
s1229l05370	2	Their “THE GOLDEN WEDDING.”\nFeaturing Charles (Daddy) Manley.\nLaemmle Drama—Released May 30.\nStory by John Fleming Wilson, Author of\n“The Master Key.”\nProduced by Frank Lloyd.\nCIL 5370\nCAST.\nCharles Darling........Daddy Manley\nJane, his wife........Mother Benson\nThe star.............Marc Robbins\nThe stage manager.....M. K. Wilson\nJane Darling is an invalid, whose husband was formerly a famous actor, but in his old age, has come down to be door-keeper at a theatre. For his wife's happiness, Charles still lets her think he is a famous star. He is helped, unconsciously, in the deception by a famous star of the present day, who has taken for a stage name the fallen star's surname and is playing at the same theatre where Charles is door-keeper, in a revival of the same play that Charles made his reputation in.\nOne day as Charles is holding his little court about the door, comprised of several children who hang about him, the star comes in and hears the old man reciting lines of the part he is playing in. He is surprised and, on talking with “Daddy,” learns that the old man at one time read the same lines to his audience. That night the impression is deep on two minds. The star, eating his lonely dinner, wonders if he will come to what “Daddy” is now, while Jane, at home, reads of the success of the play and the encomiums heaped upon the star.\nThe next day is the wedding anniversary of the old couple and Jane intends to surprise her “star” husband by going to the theatre unknown to him and watching him in his big success. At the last moment she tells her plan to her neighbor, who is horror struck at the idea, knowing, knowing that “Daddy” is only a door-keeper at the theatre and fearing that the shock of the surprise will kill her. The old lady is too determined to be turned aside and they leave for the theatre.\nAt the theatre, things are not going well, the star is late and they are anxiously waiting his arrival. When he does arrive, in his hurry to get out of his car, he slips and wrenches his ankle so badly that he is unable to go on with the play.\nHe persuades the manager to put “Daddy” on in his place, knowing his familiarity with the play, and, after many arguments, “Daddy” is finally given the part.\nHis rendition of the part is more than perfect and even the crowded galleries realize they are getting more than they paid for. Jane has taken a front seat and is unable to contain herself. “Daddy” sees her, and for an instant, falters in his lines, but his old training came into play and he goes on coolly with the part. He motions her to come back of the stage and after the performance, there is a very happy reunion. The start secretly makes the manager let “Daddy” take the part as long as the play runs so his wife will never know of the deception and as the story ends, “Daddy” comes again into the triumphs of his youth.
s1229l05370	3	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l19144	1	L-19,144
s1229l19144	2	JUN 21 1923\n\n© CIL 19144\n\nTHE GIRL WHO CAME BACK\n\nPhotoplay in 6 reels\n\nAdapted by Evelyn Campbell from the play by Charles\nE. Blaney and Samuel Ruskin Golding\n\nAuthor of the photoplay (under Sec. 62)\nAl Lichtman Corporation of the U. S.\n\n[Signature]\n\n*
s1229l19144	4	WASHINGTON, D. C.\nJUN 21 1923\n\nRegister of Copyrights\nWashington, D. C.\n\nDear Sir:\n\nI herewith respectfully request the return of the following named motion picture films deposited by me for registration of copyright in the name of\n\nAl Lichtman Corporation\n\nTHE GIRL WHO CAME BACK (6 reels)\n\nRespectfully\nFULTON DRYLAWSKI\n\nThe Al Lichtman Corporation\nhereby acknowledges the receipt of two copies each of the motion picture films deposited and registered in the Copyright office, as follows:\n\nTitle          Date of Deposit     Registration\nGIRL WHO CAME BACK   6/21/23   ©CIL 19144\n\nThe return of the above copies was requested by the said Company, by its agent and attorney, on the 21st day of June, 1923, and the said Fulton DrylawsKi for himself and as the duly authorized agent and attorney of the said company, hereby acknowledges the delivery to him of said copies, and the receipt thereof.\n\nDec 26/23
s1229l19144	3	©CIL 19144\n\nWhat Exhibitors Want to Know About\n\nB. P. Schulberg\npresents\nA Tom Forman Production\n“THE GIRL WHO CAME BACK”\nAdapted by Evelyn Campbell\nFrom the Stage Play by\nCharles E. Blaney and Samuel Ruskin Golding\nPhotographed by Harry Perry\nLength 6,100 Feet. Running Time 1 Hr. 10 Min.\nA PREFERRED PICTURE\nDistributed by the Al Lichtman Corporation\n\nTHE STORY\n\nA N unsophisticated country girl, unfortunate in her city associates—such is Sheila Weston. When the two blase shopgirls with whom she works and rooms take her to a dance hall one night, she is dazzled by the lights, the jazz—and the attentions of Ray Underhill. Ray work fast and soon he wins her consent to a justice of the peace wedding. Before they leave the justice’s house after the ceremony, officers arrive and arrest them both as auto thieves. Ray pleads Sheila’s innocence, but she has been seen driving the car and the officers refuse to believe him. Each is sentenced to prison.\n\nIn jail, Ray’s cell-mate is “648,” a trusty, and a man “framed” in a bogus trust company deal. “648” is the only man in prison whom old “555”—a lifer—ever speaks. For him the old man has strong affection, and has made “648” his heir to Kimberley diamond claims, explaining everything to him in their infrequent talks.\n\nSheila’s release comes first and she goes to the jail on visitors’ day to see Ray. She is seen by Ramon Valhays, the man responsible for “648’s” conviction. Valhays comes to see the trusty, but “648” refuses to see him.\n\nGuided by “555’s” instructions, Ray and “648” escape together and go to a house owned by “648,” where they secure clothing. Ray discovers that his convict friend has money hidden in the house, and takes a key to the front door with him when they separate.\n\nRay goes to Sheila’s and is followed by officers and captured. However, he manages to give her the key to “648’s” house with directions how to reach it. Alone, weary of the eternal grind, told by the landlady to move, under police surveillance, Sheila decides to take the money and make a new start. In the house “648” catches her red-handed, but it is dark and during the struggle she escapes with the money without being identified by him.\n\nSix years later, in Capetown, “648” has become a wealthy diamond mine owner, known as Norries, and Sheila a famous and popular beauty. She believes the report she has heard of Ray’s death, so when she and Norries meet, and fall in love, she marries him.\n\nThen comes the time when Norries must return to America and repay the money to those whose trust he had apparently betrayed. Stifling her misgivings, Sheila accompanies him and his work is nearly completed, when Valhays calls on Sheila—with Ray!\n\nThey try to blackmail her—she fears Norries’ discovery of her past, and after writing him a confession, starts to run away. Valhays has anticipated this, and intercepts her. Norries has found her letter and is reading it when he hears a scream. He rushes out and attacks Valhays, but the latter eludes him in the shubbery. Then the police, who have been trailing Valhays, reach the place. In the subsequent battle, Ray and Valhays mistake each other. Ray, however, has had a chance to tell Sheila that they were never married—the justice was a fraud.\n\nMutual explanations between husband and wife result in perfect understanding and a future full of promise.
s1229l19144	5	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l02940	12	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l02940	2	I.\n© CIL 2940\nLARSAN'S LAST INCARNATION\nFrom the celebrated novel of Gaston Leroux\nThe Perfume of the Lady in Black\n\n2.\n15 years ago, in America, Mathilde Stangerson married one\nLarsan, an escaped convict.\n\nMrs. Van Doren, of the Odeon Theatre\nin the role of\nMathilde Stangerson\n\nOn the very evening of the wedding day, Larsan arrested\nis returned to jail whence he soon escapes once more.\n\nis purpose:\nto become once more master of she who was his wife\nand whom he has loved to love.\n\nMr. Garat, of the Gymnase Theatre\nin the double role\nof Larsan and Robert d'Arzac\n\n4.\nJoseph Rouletabille\nReporter:\nMr. Jacques de Feraudy of the Comedie Francaise\n\n5.\nPART I\n\nMathilde Stangerson returns to France, to hide under her\nfather's roof, her shame and grief. Since then she is\ndearly beloved by Professor Robert d'Arzac, the chosen\ndisciple of her father, an illustrious scientist.\n\n6.\n(Newspaper insert)\n--- A Shipwreck ---\n(From New York by wireless) A cable from New-\nfoundland announces the find, amongst the victims\nof the S. S. Manitoba, of the unrecognizable body\nof the famous bandit Larsan. Some papers found\non him have helped to establish his identity.
s1229l02940	4	16. A sanitarium wherein it is easy to enter but very hard\nto leave.\n\n17. Larsan, under the alias of John Brignolles, shuts up his\npseudo brother, d'Arzac, in the sanitarium.\n\n18. (Visiting card)\nJohn Brignolles\n\n19. (Receipt form, partly printed).\nSanitarium of the Mont. Barbonnet.\nSOSPEL A.M.\n----00----\nReceived from John Brignolles the\nSum of One thousand dollars ($1,000.00) payment\nin advance of three months' board for his\nbr her Andre Brignolles.\nThe Superintendent\nValancais.\n\n20. (Letter)\nMy dear Mathilde:\nI shall be in Paris on Tuesday\nat 5.15 P. M. Eight more days and we shall\nbe united. My eyes are better, but I may\nhave to wear, permanently, smoked glasses.\nWith fond love,\nRobert d'Arzac.\n\n21. Where Larsan becomes Robert d'Arzac.\n\n22. Mathilde, accompanied by her father, meets her convalescent\nfiance.
s1229l02940	6	33. The false d'Arzac makes sure that his victim is carefully guarded.\n\n34. The false d'Arzac meets his friend Rouletabille at the station.\n\n35. In order to protect their eyes from the intense reverberation of the midday sun, all the guests wear smoked glasses.\n\n35a. A strange uneasiness seems to permeate the mansion where the guests' thoughts are as well hidden as their eyes.\n\nEND OF PART II\n\nPART III\n---O---\n\n36a. (Society Gossip).\n\nMr. Robert d'Arzac, the distinguished professor at the Sarbonne, and Mrs. d'Arzac, who have just been married in Paris, are spending their honeymoon at the Riviera, as the guests of Sir Arthur Rance, at his mansion "Hercules".\n\n37. A fire breaks out suddenly, in the sanitarium and Robert d'Arzac escapes.\n\n38. In order to lull Mathilde's suspicion, the false d'Arzac imagines to have her see the real d'Arzac prowling around the mansion.\n\n39. "We have just seen Lawsan, the wretch is not dead..... anything may be expected....we must protect Mathilde d'Arzac..."\n\n40. While they are organizing for defence, the real d'Arzac, nears the mansion.\n\n41. Rouletabille personally watches the postern.\n\nEND OF PART III
s1229l02940	11	-3-\n\nwhat fearful revelation was going to take place. There are here\ntwo Robert d'Arzaes, they are informed by the reporter, that is\none too many. At this, Robert appears to the astonishment of\nhis friends. Taking advantage of the excitement caused by the\nreturn of Larsan, the latter hidden in the room and seeing him-\nself lost, takes poison.\n\nThus Rouletabille having delivered both his friends and\nthe world of a redoubtable bandit, Mathilde and Robert will at\nlast be able to live in peace and happiness, forgetting the ter-\nrible past.
s1229l02940	10	-2-\n\nin his triumph, the unfortunate d'Arzac, a prisoner, powerless\nand vanquished, is waiting for a favorable turn of fate to help\nhim to escape. He knows nothing of the outside world and has no\nhope of seeing Mathilde again. He is ignorant of the fact that\njustice working in darkness is preparing a final victory for him.\n\nThird part.\n\nRobert d'Arzac finds a newspaper. Under Society News\nhe learns of his misfortune. Mathilde is married and the bridal\ncouple is at the Chateau d'Hercule. A fire breaks out in the\nasylum and the professor succeeds in escaping. It is night and\nRobert flees along the river, fearful of being pursued. A vivid\nsetting of the sun seems to add an aureole of blood to this the\ndrama which is unfolding itself.\n\nThe inhabitants of the chateau go on living without daring to confess their fears. The false d'Arzac, to remove all\nsuspicions from Mathilde, conceives the idea of appearing as his\ntrue self, prowling around the old domain. Who could still suspect\nhis being Larsan, when the real bandit will have shown himself, yonder, on the sea. He can be seen from the chateau, borne here\nand there by at the will of the sea, a menacing shadow of irony profiled against the darkened sky. The worthless Larsan is not dead.\nThere is much to be feared and and the line of defense must be planned. Mathilde must be protected; Rouletabille gives orders to\nthe servant of the chateau, and he himself, a veritable hero, takes\nup his post at the gate.\n\nHowever, at nightfall the true d'Arzac approaches the\nchateau.\n\nFourth Part.\n\nRouletabille and the inhabitants of the chateau can have\nconfidence in his vigilance. The false d'Arzac is writing at\nhis table; slowly a door opens as if pushed by an unknown hand. A\nsad and serious face appears. The real d'Arzac is opposite his\nenemy. Larsan seizes his revolver and fells the young man. Bri-\ngnolles rolls the body smeared with blood into a blanket. For\neveryone Larsan has just been killed. However, the wound received\nby Robert is a slight one and the two accomplices escort their\nvictim back to the asylum at Mount Barbonnès. But a note lost\nduring the scuffle between the two rivals puts Rouletabille on an\ninteresting track. He discovers the place where the real d'Arzac\nis incarcerated. All the inhabitants of the chateau are invited to go to d'Arzac's room immediately. With anguish in their\nhearts, they respond to the invitation of Rouletabille wondering
s1229l02940	7	42.\nPART IV.\nTruth on the way.\n\n43.\n"The best way to get rid of him is to shut him up once\nmore....."\n\n44.\n"He is lucky.....The ball flattened itself on the sternum\nand only produced an internal hemorrhage."\n\n45.\nNext day, Rouletabille, makes an important discovery.\n\n46.\n(Flash of #19.)\n\n47.\n"How is your brother?...what...Have you not a brother\ncalled Jean Brigosolles.....This is strange!!!...."\n\n48.\n"Lead me to the Mont Perhonnet Sanitarium."\n\n49.\n"d'Arzac is shut up in there?.....\nOne word, one sign.....I'll blow your brains out!....."\n\n50.\n(Back of a visiting card).\nLet everyone assemble in d'Arzac's room.\n\n51.\n"I have noticed a phenomenal thing; there are in this room\ntwo d'Arzacs, one real and one false. There is one too\nmany. What do you think?"\n\n52.\n(Letter)\nI still loved you, Mathilde, I was your\nhusband and I wanted you to myself. An outlaw,\nI have tried to make a new personality for my-\nself so as to be able to live in the open with\nyou. This will explain everything.\nForgive and...adieu...\nLarsan.
s1229l02940	9	- Larsan's last incarnation -\nfrom the novel THE PERFUME OF THE LADY IN BLACK. by B. Leroux.\n\nFirst Part.\n\nMathilde Stangerson a long time back had married in\nAmerica, an escaped convict, who was arrested a few days after\ntheir marriage. She thereupon exiled herself in Europe,\nto hide her sorrow, and there met Robert d'Arzac, a young pro-\nfessor at the Sorbonne, learned and courteous. A rumor having\nreached Mathilde of the bandit's death, she becomes engaged to\nRobert.\n\nBut Larsan is not dead. In connivance with Brignolles\nwho is d'Arzac's assistant, he plots to get revenge on his rival.\nDuring an experiment, prepared by his aide, the professor is the\nvictim of an explosion which half blinds him. The doctors de-\ncide that the young professor should be sent to San Remo. But\nthe young man, pursued by his invisible enemy, will not return\nto his beloved after his convalescence. Brignolles has him\nconfined in an insane asylum at Mount Barbonnès. Larsan has\nconceived the idea of hereafter impersonating Professor d'Arzac.\nWith the aid of a photograph of Robert, he makes up with a great\ndeal of skill. The resemblance is striking. While the true\nd'Arzac is undergoing the horrors of his imprisonment his dreaded\nrival is preparing to steal from him his property and his happi-\nness.\n\nSecond Part.\n\nThe marriage of Mathilde and the false professor is\ncelebrated, and the young couple go to the Côte d'Azur to enjoy\ntheir honeymoon. However, notwithstanding the fact that Ma-\nthilde's father accompanies them, she is uneasy. She is in con-\nstant fear of seeing Larsan again, whose sudden returns and dar-\ning transformations are celebrated in the annals of crime.\nSuddenly, in the dressing room of the train the young woman is\ncertain of having seen the bandit. She screams, her father\ncomes to her. It can only be a hallucination. D'Arzac is next\nin the next compartment, has seen nothing. However, Mathilde\nis not reassured and secretly sends a telegram to Rouletabille\nthe clever and courageous reporter, her friend.\n\nThe newly-wed couple live in the Chateau of Hercules,\nan old and quiet habitation by the sea. The false d'Arzac\ngoes personally to meet Rouletabille, so as better to throw him\noff the track. To prevent the intense reverberation of the\nsun they use dark goggles which adds to the weirdness of the\nplace, and the subtle reporter tries in vain to fathom the mys-\ntery which envelops him. Mathilde's feminine instinct has told\nher that she was in danger. It will now be Rouletabille's duty\nwith the aid of his audacious keenness to solve this terrible\nproblem. If Larsan is not dead, where is he hiding himself.\nIt is imperative for the peace of everyone that he be caught\nbefore committing further crimes. While the bandit is gloating
s1229l02940	3	7. "Mathilde is now free, and nothing my dear children, prevents you from being happy."\n\n8. Larsan is not dead. He landed secretly at Marseilles, and he gathers from the newspapers that his trick has been successful.\n\n9. (Newspaper Insert)\n\n--- SOCIETY NEWS ---\n\nThe betrothal of Mr. Robert d'Arzac, Professor at the Sorbonne, with Madame Mathilde Stangerson, daughter of the illustrious scientist, is announced.\n\n10. Once, in Paris, Larsan plans with his accomplice Brignolles, Robert d'Arzac's assistant, the perpetration of a criminal attempt on d'Arzac.\n\n11. Robert d'Arzac invites his future father-in-law and Mathilde to assist at his latest experiment.\n\n12. The dastardly Brignolles informs Larsan that his crime has been successful. d'Arzac has been almost blinded and the doctors have ordered him to be taken to San Remo.\n\n13. Both Larsan and his victim will travel to the Riviera in the same train.\n\nThree months later.\n\n14. Robert, now convalescent, informs Mathilde of his prompt return and fixes a date for their marriage.\n\n15. (Letter)\n\nTo the Superintendent of the Sanitarium of the Mont-Barbonnet, Sospel (Alpes Maritimes)\n\nSir:\n\nMy brother is mentally deranged. He fancies he is a professor at the Sarbonne. I am obliged to place him in your care. Enclosed please find medical certificates. I will bring him tomorrow.\n\nJohn Brignolles.
s1229l02940	5	23. .....while the real d'Arzac is undergoing the horrors of\nthe padded cell.\n\nEND OF PART I\n\nPART II\n\n24. At the reporter's, Joseph Rouletabille, the intimate\nfriend of the Stangersons and d'Arzac.\n\n25. (Wedding announcement)\n\nMr. Henry Stangerson, officer of the Legion\nof Honor has the honor to announce the marriage\nof his daughter Mathilde to Mr. Robert d'Arzac,\nprofessor at the Sorbonne.\nParis, April 6, 1895.\n\n26. The wedding, strictly confined to friends, was performed\nin the church of St. Nicholas du Chardonnet.\n\n27. The bride's witnesses, Mr. and Mrs. Rance place their\nmansion "Hercules"at the disposal of Mr. and Mrs. d'Arzac,\nfor their honeymoon.\n\n28. "He!.....He!!.....Larsan!!!....."\n\n29. The next day, before reaching Lyons, Mathilde, still a prey\nto terror sends a telegram to Rouletabille.\n\n30. (Telegram)\n\nRouletabille Paris\nHelp!\nMathilde.\n\n31. At the "Hercules" mansion.\n\n32. (Telegram)\n\nI am coming\nRouletabille.
s1229l02940	1	L 2940
s1229l02940	8	53. "There was one corpse too many..... no one will notice his disappearance."\n\n54. (Telegram)\n\nJoseph Rouletabille\n"Hercules" mansion.\n\nLeave at once for Russia. The Czar is asking for you.\n\nSchneider.\nManager of the paper "L'Epoque"\n\n55. FINIS.
s1229l08428	2	3.\n\nstuff taken from Gournay-Martin and it has all been restored to\nthe owner's Paris house: according to the newspapers, this in\nitself is evidence that Lupin is no longer in the land of the\nliving!\n\nSo the great man returns to his faithful followers, and\nin a series of exciting and amusing scenes he outwits Guerchard\ncompletely. In the tightest of corners he escapes, for when\nArsène Lupin is apparently captured, handcuffed in the prison\nvan, with the triumphant detective at his side, Guerchard is\nreally on the eve of a great humiliation. When the\nvan reaches the police-station, it is Guerchard and his men who\nare found gagged and bound inside.\n\nGuerchard never succeeds in taking Lupin; but Sonia,\nwhose love for the "Duke of Charmerace" does not cease when\nshe discovers him to be Arsène Lupin, the thief, persuades him not\nonly to make restitution but also to expiate his offence against\nsociety. In his great love for Sonia, Lupin consents: he gives\nhimself up to Guerchard and pays his debt. But each dawn, as she\nhad promised, Sonia stands where Lupin can see her from his\nprison window.
s1229l08428	3	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l08428	1	JUN -5 1916\nGLORIA'S ROMANCE, Chapter Six,\n© CIL 8428\nHIDDEN FIRES\n(Copyright Description)\n\nMiss Burke herself, as prologue, speaks the lines\nup to date, while dressed as a clown, or Pierrot, introducing\nfather, Pierpont Stafford, the great banker; her brother David, his wife, her\nfiance, Richard Freneau, and Drs. Royce and Wakefield.\n\nAs the main action of the chapter opens, Gloria's\nwatch over her— with Dr. Royce, while her life hangs in\nFreneau, her fiance, is not allowed to see her, but brings\ncare of Royce, who loves her, she becomes convalescent. Royce\nsent of a pair of binoculars, through which she can see River\nriver and the surrounding country from her window. He plays\nby placing the thermometer against her hot water bath\nsky-ward. The doctor thinks her fever is rising and\nGloria laughs at him and the joke is explained.\n\nNell Trask, one of Freneau's victims, is\nhospital to which he has been taken after being\nauto. Trask tells her of the attack\nFreneau in his own apartment but is told\nFreneau's, sends an anonymous\nthe intrigue between Freneau\nher he is going to leave town soon and be gone ten days. Freneau who tries to break off his liaison with her. He, however, her fury, is forced to agree to a final trip with her. He\nhow to explain his absence, during this trip, to Gloria, and his partner Mulry. Mulry suggests that Freneau write letters\nstationery of hotels in various cities, and that he, Mulry\nfrom the towns he visits during his trip to their branch\nsend telegrams to Gloria in Freneau's name and thus she will\nis on a business trip. Freneau agrees and spends most of the\nfalse letters and telegrams.\n\nMeanwhile Gloria is on the high-road to recovery and insists upon\nordering her wedding gown, which she does. That night she\ndreams a dream of\nhappiness — she sees herself married to Freneau.\n\nbringing the story\ng incidentally her\nfather and brother\nin the balance. Even\nflowers. Under the\nce makes her a present\nerside Drive, the\n; a joke on the doctor\nnding the mercury\ncantically for ice.\n\nfather in the\npursuing Freneau's\n. She seeks Freneau\nan old flame of\nrid, warning him of\ns wife, David tells\nhis hastens to Freneau, fearing the results of\nis at a loss as to\nd seeks counsel of\ns to Gloria on the\nwill mail the letters\nffices. He will also\nll believe that Dick\nhe night writing the\n\nCopyright, 1916, by George Kleine.\n\nL8428
s1229l19504	2	OCT 17 1923\n\nWashington, D. C.\n\nRegister of Copyrights\nWashington, D. C.\n\nOctober 17, 1923\n\nDear Sir:\n\nI herewith respectfully request the return of the following\nnamed motion picture films deposited by me for registration of\ncopyright in the name of The Regenet Film Company\n\nA WOMAN OF PARIS (8 reels)\n\nRespectfully,\n\nFULTON BRYLAWSKI\n\nThe Regent Film Company\nhereby acknowledges the receipt of two copies each of the\nmotion picture films deposited and registered in the Copyright\nOffice as follows:\n\nTitle                  Date of Deposit          Registration\nA Woman of Paris      10/17/1923               ©CIL 19504\n\nThe return of the above copies was requested by the said\nCompany, by its agent and attorney on the 17 day of\nOct., 1923 and the said Fulton Brylawski for himself, and as\nthe duly authorized agent and attorney of the said Company,\nhereby acknowledges the delivery to him of said copies, and\nthe receipt thereof.\n\n[Signature]\n\n[Signature]
s1229l19504	5	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l19504	3	OCT 17 1923\n\n©CIL 19504 e V A WOMAN OF PARIS\nPhotoplay in eight reels\nWritten and directed by Charles Chaplin\nAuthor of photoplay (under Sec. 62)\nThe Regent Film Company of the United States\n\nMR
s1229l19504	4	OCT 17 1923\n\nFirst Advance Stories—Cast and Synopsis\n\nMR. CHAPLIN’S FIRST\nPHOTOPLAY DRAMA\n\n“A Woman of Paris,” Great\nStar’s Initial Serious Production, Coming Here Soon.\n\n“A Woman of Paris,” the first\nCharles Chaplin serious production\nfor United Artists Corporation, will\nbe the attraction at the………………\ntheatre, starting next……………for an\nindefinite engagement.\n\nThis important announcement is\nmade by Manager………………, who\nat great cost procured for presenta-\ntion this remarkable photoplay; the\nfirst dramatic contribution produced\nby the great genius of the screen—\nCharles Chaplin.\n\n“A Woman of Paris,” written and\ndirected by Chaplin, marks a new de-\nparture in almost every element that\ngoes to make up a motion picture.\nThe treatment of the story is entirely\ndifferent from anything heretofore\nseen in the photoplay theatre. While\nthe theme deals with life as it really\nis, the psychological study presents\nlife’s problems from a viewpoint that\nis more one of understanding than of\npreachment. The story unfolds an ex-\nquisite tapestry, woven around a\nwoman’s soul naked in its sincerity\nthough clothed in its individuality.\n\nAlmost an entire year was con-\nsumed in the making of “A Woman\nof Paris” and while there are no huge\nsets, no mob scenes, no elaborate\nmechanical effects, the time devoted\nwas in the perfection of the action and\nthe fidelity to detail in the treatment\nof the story.\n\nEdna Purviance, who has been\nidentified with Chaplin in almost all\nof his comedy productions, rises to\ngreat heights in her career as the star\nof “A Woman of Paris.” Unthought\nof qualities of histrionic capabilities\nhave been revealed under the careful\ndirection of Mr. Chaplin. Adolphe\nMenjou, well known screen actor,\nplays the leading male role, while\nother important members of the cast\ninclude Carl Miller, Lydia Knott,\nHarry Northrup, Malvina Polo, and\nothers well known in the picture\nworld.\n\nTHE DRAMA IN LIFE\nIS CHAPLIN THEME\n\nGenuine Humanity in Great Star’s\nFirst Serious Picture, “A\nWoman of Paris.”\n\nTo the fair sex who must always\nremain beautiful, the beauty parlor has\nalways been known not only as a\nmeans for beautification, but a source\nfrom whence the latest gossip and\nscandal emanates. It is generally ad-\nmitted that milady’s hairdresser and\nmasseuse is always hearing the latest\nsecrets of her fair clients, and part of\nher stock in trade is being able to\nimpart the newest gossip.\n\nIn Charles Chaplin’s first serious\nphotoplay production, “A Woman of\nParis,” starring Edna Purviance, his\ninitial United Artists Corporation at-\ntraction now playing at the……………\ntheatre, a scene is depicted showing\nMarie St. Clair, played by Miss Purvi-\nance, receiving her morning beauty\nmassage in her boudoir.\n\nCHAPLIN’S PICTURE\nBLAZES NEW TRAIL\n\n“A Woman of Paris,” a Portrayal\nof Life As Actually Lived—His\nFirst Serious Production.\n\nPredictions are being made that the\nscreening of Charles Chaplin’s own\nstory in “A Woman of Paris,” star-\nring Edna Purviance, will stand forth\nin motion picture history as an epi-\nchal event that will exert a strong in-\nfluence on the present day photo-\ndrama.\n\nThe entire story and production,\nconceived and produced by this mas-\nter cinema genius promises to reveal\na treatment of a vital problem, pre-\nsented with extreme simplicity yet\nwith an unbounded psychological\nforce that will blaze a new trail along\nthe highway of motion picture\nprogress.\n\nThe theme is a startling one, and\nmade the more so because of the ut-\nter simplicity and warmth of feeling\nthat permeates it. It presents a prob-\nlem dealing with the basics and funda-\nmentals of life, commenting upon it\nin interesting fashion rather than at-\ntempting to solve it.\n\nWhile the story is of life as studied\nby Charles Chaplin, it in no wise deals\nwith the life of Chaplin but with the\nlives of others as seen by him. And\nas in actual life, there is comedy,\ntragedy, passion, absurdity, melo-\ndrama, farce, emotionalism, cynicism\n—all these Chaplin has combined as\ningredients of life in “A Woman of\nParis.” At the same time he has\nwoven an exquisite tapestry portray-\ning the sincerity of a woman’s soul in\nall its nakedness though clothed in\nits individuality.\n\nDealing with lives and types that\nhe knows, Chaplin brings to the screen\nhis first contribution to the serious\ndrama a story as old as that of Adam\nand Eve yet presented with such con-\nvincing understanding and treatment\nthat it will be a revelation in the art\nof photo dramatics.\n\n“A Woman of Paris” will be pre-\nsented at the………………theatre\nstarting an indefinite engagement next\n…………………, being the first\nCharles Chaplin production to be re-\nleased through United Artists corpo-\nration, the combined organization of\nthe foremost stars and producers of\nthe motion picture industry, Mary\nPickford, Charles Chaplin, Douglas\nFairbanks and D. W. Griffith.\n\nIn delicious strokes of subtle\nhumor, while the masseuse is busily\nmassaging the draped form of the\nbeautiful Marie, one of her girl friends\ndrops in for a morning visit.\n\nBubbling over with the latest scan-\ndal which she had witnessed the\nnight before, she is telling how she\nhad seen Paulette in the company of\nMarie’s friend. While in the midst of\nthe recital of this bit of scandal, Paul-\nette appears on the scene.\n\nThroughout the scene the stoical\ncountenance of the masseuse has re-\nmained unchanged, yet drinking in\nthis tasty morsel, the blank expression\non her face, the seeming utter lack of\nunderstanding is a work of art. This\nscene is one of the many human\ntouches which abounds in “A Woman\nof Paris,” this Charles Chaplin drama,\none of life as it actually is lived by\nfolk we all know.\n\nCAST AND SYNOPSIS\nfor\n“A WOMAN OF PARIS”\nA Drama of Fate\nFeaturing\nEDNA PURVIANCE\nWritten and Directed\nby\nCHARLES CHAPLIN\n\nA story of a woman’s heart, carrying with it the supreme problem\nof the ages—humanity being composed not of heroes and villains, but\nof men and women, and all their passions, both good and bad, have been\ngiven them by God. They sin only in blindness, and the ignorant con-\ndemn their mistakes, but the wise pity them.\n\nAssistant Director, Eddie Sutherland; Editorial direction, Monta Bell;\nBusiness Manager, Alfred Reeves; Photography, Rollie\nTotherch and Jack Wilson; Research,\nHarry D’Arrast and Jean di Limur.\nReleased by United Artists Corporation\n\nTHE CAST\n\nMarie St. Clair…………………………Edna Purviance\nPierre Revel ……………………………Adolphe Menjou\nJohn Millet ………………………………Carl Miller\nHis Mother ………………………………Lydia Knott\nHis Father ………………………………Charles French\nMarie’s Father …………………………Clarence Geldert\nFifi and Paulette—Friends of Marie\nBetty Morrissey and Malvina Polo\n\nTHE SYNOPSIS\n\nMarie St. Clair is young and unsophisticated, a victim of the environ-\nment of an unhappy home life in a village somewhere in France. In the\nhope of finding love and solace with her village sweetheart, John Millet,\nshe decides to elope to Paris and be wed.\n\nOn the eve of their elopement, Marie having secretly left her home\nto talk over plans with John, finds on returning that she has been\nlocked out by her tyrant father. Then she is refused the hospitality of\nher lover’s home by his parents, and the couple decide to run away that\nnight.\n\nMarie, waiting at the station while John returns to his home to\ngather his belongings, becomes impatient. An interrupted telephone con-\nversation with him causes her to believe her intended husband has\nchanged his mind about the elopement. This belief, and the timely arrival\nof the midnight train, prompts her to go to Paris alone.\n\nTime brings many changes, and in a few short months life has made\nof Marie St. Clair “A Woman of Paris,” the beautiful toy of Pierre Revel,\nthe wealthiest man in the gayest city in the world.\n\nAt the height of a luxurious life of loveless gaiety the engagement\nof Pierre to a woman of social and financial prominence is announced.\nThis brings a rift in the code of understanding between Marie and Pierre.\nHe insists that their life as it is will not and must not be interfered with,\nwhile she demands for herself a home and genuine love.\n\nTime makes strangers of erstwhile intimate friends, and in the course\nof events Marie is invited by one of her young woman friends to join\na studio party in the Montmarte. Not having the correct address she\naccidentally knocks on the door of her one time sweetheart, John, whose\nstudio is in the same vicinity and who has gone to Paris with his mother\nto continue his art studies.\n\nThis surprise meeting and the apparent difference in their lives finds\nthe two in an embarrassing situation. Formality covers their real and\nmutual emotions and it is arranged that Marie pose for her portrait. In\nthe weeks of posing there arises in Marie’s mind this problem—Marriage\nor Luxury? And in the meantime the old love, still smoldering, bursts\ninto renewed flame.\n\nJohn again proposes marriage, still loving her devotedly in spite\nof everything. Marie, overjoyed at the thought of a real home, and of\nchildren, loses no time in telling Pierre that they must part. Making all\npreparations to give up her life of loveless luxury, she returns to John’s\nhumble studio which to her means love and happiness. Entering, she\noverhears a conversation between John and his mother in which John\nis saying he does not intend to marry Marie; that he proposed to her\nonly in a moment of weakness. This fact, coming so suddenly and as\nsuch a shock to Marie, hurls her back onto the mercies of Pierre.\n\nDays pass, and remorse and despair control the fate of John Millet.\nHis love for his erstwhile village sweetheart becomes an obsession. He\nfollows her everywhere, dogging her footsteps, watching her apartment\nnightly, until he becomes possessed by a mania to end his life. He de-\ncides to kill both Marie and Pierre, but weakens. Distracted by his\nemotions he follows them to a cafe, sending a note to Marie in the hope\nof clearing their misunderstanding. Pierre invites John to join them.\nWords and hasty tempers bring on the inevitable fight. John is ejected\nfrom the cafe and left standing under the brilliant lights of the entrance,\nwhere a sparkling fountain with its nude statue, symbolic of a woman\nof Paris, seems to mock him. In utter despondency John ends the struggle\nof his seared soul.\n\nTHE UNEXPECTED IN\nCHAPLIN PHOTODRAMA\n\nMany Strange Happenings in “A\nWoman of Paris,” His First\nSerious Production.\n\nIt is the unexpected, unforeseen\nhappenings in life that tend to make\nliving interesting. In “A Woman of\nParis,” Charles Chaplin’s drama of\nlife, coming to the………………\ntheatre, are the unexpected happen-\nings of the photoplay, showing some-\nthing new and different in the motion\npicture, creating new and added inter-\nest to this form of the public’s enter-\ntainment and recreation.\n\nIn the first place it was unexpected\nthat the justly famous Charles Chap-\nlin should even temporarily desert his\ncomedy roles for the production of\nthe serious drama. It had been un-\nthought of that he would produce a\nphotoplay in which he himself did not\nappear, yet these and more unfore-\nseen happenings have come to pass,\nand it is the unexpected incidents that\nappear in “A Woman of Paris” that\nmake it the most interesting photo-\ndrama yet produced.\n\nIn this Charles Chaplin production\nfor United Artists Corporation, the\nmovie fan who can always anticipate\nthe next incident or what will follow,\nis going to meet with a reversal of\nform. Chaplin outguesses one at\nevery turn. Where one may visualize\na scene to follow or what will next\nhappen, one is treated to something\nentirely different, yet there is never\nany feeling of disappointment, so\nquickly does one realize that he is\nwitnessing something just a little bet-\nter than he anticipated, something\nnew, something more interesting,\nsomething altogether away from the\nstereotyped form of movies.\n\n“A Woman of Paris” is a distinct\ndeparture from anything heretofore\never presented on the motion picture\nscreen.
s1229l19504	1	L-19,504
s1229l05314	1	2 <3)→
s1229l05314	3	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l05314	2	“HIRAM’S INHERITANCE.”\nJoker Comedy—Released May 24.\nWritten by C. G. Badger. Produced by\nAllen Curtis.\n© C.L. 5314\nCAST.\nHiram…………………………Max Asher\nArabella………………………Gale Henry\nZeke…………………………William Franey\nTillie…………………………Lillian Peacock\nHiram and Zeke love Arabella. The\nmatter reaches the stage of acute conten-\ntion. Finally Arabella settles things by\naccepting Zeke. Hiram is bitterly sore.\nZeke and Arabella start to hitch up to\ndrive to the parson’s. At this point, Ara-\nbella is handed a letter by the postmaster\nto deliver to Hi. Overcome by curiosity,\nArabella manages to read it. It reveals\nto her the fact that Hi has inherited a\nlarge sum of money, which will be for-\nwarded in a few days. She tears the let-\nter u pand returns to Hi, showering him\nwith affections. Poor Zeke is left in the\ncold. Arabella rushes Hi to the parson’s,\nwhere they are married.\nNow Arabella has a maid-of-all-work,\nnamed Tillie. Tillie has long and secretly\nloved Zeke. She is delighted with the\npresent turn of affairs, but Zeke, broken-\nhearted, still refuses to pay her atten-\ntions.\nDuring the wedding dinner Arabella\nhears Zeke’s familiar whistle. It haunts\nher. She goes to him and endeavors to\nsoothe him. Hi witnesses the act. He\nmisunderstands, and, enraged, he sends\nZeke about his business, starting an argu-\nment with his bride. She turns on him\nfuriouly. Her remarks cut him deep, and\nhe determines to drown himself. Hi goes\ndown to the river. To scare Arabella, he\nleaves his hat and coat on the bank and\nthen hides in the barn loft.\nArabella is terribly upset when she\nreceives word of the supposed death of\nher groom. Zeke, on the contrary, is\noverjoyed. He finds Arabella grieving in\nthe barn. He endeavors to renew his suit\nfor her hand. Hi is a very interested lis-\ntener in the loft above.\nHi’s inheritance comes. It is brought\nto Arabella in the barn. Hi is flabber-\ngasted when he overhears the conversa-\ntion. And when he hears Zeke trying to\npersuade Arabella to forget the “poor\ndub,” take his money and marry him,\nZeke, it is more than Hi can stand. He\nalights into the situation like a thunder-\nbolt and certainly routs Zeke. Arabella\nis hysterical with joy.\nZeke now decides that Tillie is the girl\nfor him, anyhow, and the four of them\nleave for the parson’s.
s1229l11157	1	L 11.137
s1229l11157	4	- B -\n\nSeated alone by the fire place, in the La Roche mansion, La Roche's\nheir, the "Little Chevalier" is gazing into the flames. A smile, half sorrow,\nhalf mischief plays in his features.\n\nThe second reel opens at the Governor's castle. 'Tis Twelfth Night.\nA ball is in progress and the ceremony of the King Cake, takes place according\nto ancient French traditions.\n\nA bean is hidden in the cake. The lucky lady who finds the bean in her\nportion is the Queen of the evening and can choose whoever she pleases for her\ncompanion King among the gentlemen present, handing the bean to the gentleman\nof her choosing.\n\nValdeterre has been invited. The beautiful Diane de la Roche, daughter\nof the late Chevalier is also among the guests. Philippe Delaup, her most\nardent suitor expectantly watches her pick her portion of the King Cake.\n\nValdeterre, unacquainted with the identity of the beautiful girl\ngreatly admires her.\n\nDiane's portion of the cake contains the lucky bean. She accidently\ndrops it and a number of the gentlemen present quickly bend down to pick it\nfrom the floor. Among them are Delaup and Valdeterre. Both are nearest to the\nprize but Valdeterre, quicker than Delaup, picks up the bean and proffers it to\nDiane, the now Queen of the party. Diane has an admiring glance for Valdeterre\nand tells him he may retain the bean, thus consecrating him her King.\n\nWhile dancing is in progress, Diane and Valdeterre repair to one of the\nguest rooms. A case of love at first sight. But just as Valdeterre remarks:\n"So, mademoiselle, by your grace, I am your King, and you are...." Delaup\nsteps in and conveniently ends the sentence: "Mademoiselle de La Roche."\nStartled, Valdeterre jumps back, realizing, then coldly introduces himself.\nDiane replies, mockingly: "Permit me, in my turn, to make myself known Monsieur.\nI am Diane de La Roche." But Valdeterre retains his cold attitude and, her ex-\npectant expression turning to haughty disdain, she takes Delaup's proffered arm\nand exits.\n\nMeanwhile, Dominique has called at Valdeterre's hotel, bringing in a\nmessage which he has been instructed to deliver to Valdeterre personally, and,\nin spite of old Chapron's protests, has made himself quite at home in Valdeterre's\nroom to await his return.\n\nValdeterre loses himself in boundless sorrow, realizing now that Diane\nis gone, that he has fallen in love with the daughter of his hereditary enemy.\n"Surely I am but the plaything of some grotesque and terrible fate...and nothing\nis left for me but to flee fate and Diane..." is his conclusion and Valdeterre,\nunnoticed, leaves the ball and returns to his hotel.\n\nThere he is handed Dominique's message by Dominique himself. Dominique\nwaits for an answer. Valdeterre is frowningly reading the message.
s1229l11157	2	#2521\nAUG -1 1917\n© CLL 11157\nTHE LITTLE CHEVALIER\nCAST (Grebo)\nHenry, son of the slain Count of Valdeterre\nChapron, Valdeterre's devoted old servant\nDominick, a member of the de la Roche household\nDelaup, secretary to the Governor of Louisiana\nThe Little Chevalier\nDiane de la Roche\nRay McKee\nJoseph Burke\nWilliam Wadsworth\nRichard Tucker\nShirley Mason\nShirley Mason\nDirected By Alan Crosland\nPublished By Wroughton\nGriffith & Company.\nTHE LITTLE CHEVALIER\nStory by\nM. E. M. Davis\nScenario by E. Clement d'Art\nFRANCE, 1734.\nIn a duel the Chevalier de la Roche kills his friend, the\nVicomte de Valdeterre.\nHis friends advise him to depart for the far away colony of\nLouisiana ere the wrath of the King can manifest itself. Reluctantly, the\nChevalier takes their advice.\nThe families of La Roche and Valdeterre, formerly united through\nbonds of friendship are now at odds.\nHenri, Valdeterre's 8 year old son, acting under his mother's\nsuggestions, swears that when he is a man he shall avenge the death of his\nunfortunate father.\nNEW ORLEANS, 1752.\nEighteen years later, Henri, now a full grown man has reached the\nshores of Louisiana, bent on fulfilling his oath of revenge. With him is\nhis old trusted servant; Chapron.\nDominique, servant in the house of La Roche brings a message to Valdeterre\nannouncing that "he has been sent by the Chevalier de La Roche."
s1229l11157	6	-5-\n\nthe contract."\n\nJoyously Valdeterre rushes with the contract to the La Roche estate.\n'Tis night and moonlight. Diane has been walking through her beautiful garden\nand is now resting on a seat. There Valdeterre discovers her and with burning\nwords of love discloses their respective fathers' will as disclosed in the con-\ntract. Diane responds but finally remarks that: "People say things in the moon-\nlight which they regret after...I shall answer you in the morning...if you are\nstill of the same mind..." She then adds, as Valdeterre insists: "If Monsieur\nDelaup had not warned me, I might answer, but..."\n\nValdeterre, aroused, repairs immediately to Delaup's room, next to his\nown, in the same hotel.\n\nDelaup is engaged in opening mail which obviously does not belong to\nhim. Among other things, a letter addressed to Valdeterre has fallen into his\nhands. This, after perusing, he carefully pockets, judging that he can make very\ngood use of it.\n\nValdeterre burst into Delaup's room, asking: "By what right, Mr. Delaup,\ndo you slander me?" Then Valdeterre stops short, realizing what Delaup's occu-\npation has been, crosses to Delaup's table and verifies his suspicions. Using this\ndiscovery as a lever, Valdeterre forces Delaup to resign his position as secretary\nto the governor and forces him to return the "borrowed" mail.\n\nDelaup, enraged, remembers the letter he has pocketed before Valdeterre's\narrival. Quite decided to use it against his present enemy, Delaup repairs on the\nfollowing morning to the La Roche mansion. There he begs Diane to marry him.\nDiane refuses. Delaup suggests that she may soon need someone with enough money\nto support her and hers...Diane is surprised and asks for an explanation. Delaup\nhands her the contents of Valdeterre's letter: the King's renewed order to seize\nthe La Roche estate and fortune.\n\nThe elated Valdeterre calls, as Diane proposed, for an answer to his\nlove. But Diane will not receive him.\n\nHaughty, she turns on the now triumphant Delaup: "And where did you\nget these papers, Monsieur Delaup?" Delaup vainly endeavors to justify himself;\nDiane will not hear and when he asks for the return of the papers, she registers\nshe will retain them. A. Delaup insists, she turns to the bell to call in the ser-\nvants. Delaup leaves, crushed.\n\nLater, Valdeterre, mourning over his hopeless love, receives a message\nsigned Valcour de la Roche, inviting him to call in the famous garden which once\nhas been his--according to the enclosed papers (the King's order and a letter)\nwhich have fallen into his hands) it is no longer his, but Valdeterre's.
s1229l11157	7	-6-\n\nValdeterre begins to understand why Diane refused to see him. He hesi-\ntatingly picks up his sword, then deliberately puts it down again; no matter what\nhe may think of him, Valdeterre is going to face Valcour, but will not fight.\n\nLeaving his sword behind, Valdeterre starts off and duly meets Valcour in\nthe clearing. The latter looks at him in wonderment: "What, Monsieur! have you\nforgotten the problem that waits to be solved?...or are you afraid of results?"\nValdeterre replies, looking down: "Monsieur le Chevalier, I refuse to cross\nswords with you...Think of me what you will." There is a sobbing note in the\n"Little Chevalier's" voice when he replies and Valdetêrre quickly looks up--to be\nconfronted by the presence of Diane who has quickly removed her long boy's cloak\nand revealed herself, her true self. The "Little Chevalier" is a myth, a disguise\nadopted by Diane to defend the honor of her family,\n\n"How could you have been so stupidly blind, Monsieur de Valdeterre?"\nshe asks. Valdeterre clasps her in his arms.\n\nIn frenzied anger, Delaup, who from a distance, has been watching, lifts\na pistol and aims carefully, but just as he is about to shoot, Dominique, who has\nfollowed Delaup, steps in and forces him to drop the pistol.\n\nThere is much happiness at hand for Diane and Valdeterre.
s1229l11157	3	-2-\n\nThe message is obviously a reply to a letter already sent by\nValdeterre and an invitation to call on La Roche in his garden and receive\nsatisfaction to his demand for a duel. Valdeterre is to follow the bearer\nof the message.\n\nValdeterre, suffering from illness contracted during his voyage,\nChapron vainly pleads with him to remain and wait till he has recovered.\nQuite decided, Valdeterre follows Dominique.\n\nThey are seen leaving the hotel at which Valdeterre stays by\nPhilippe Delaup, secretary of state to the Governor of Louisiana and a\nmeddler in other people's affairs. Delaup watches them walk off and enter\nthe property of the La Roche family. Obviously Philippe Delaup does not\napprove of this visit, the purpose of which he is ignorant of; his suspicions\nleading him into totally wrong channels of thought.\n\nAt the gate of the La Roche estate, Dominique directs Valdeterre\ntowards a distant clearing and remains behind, then later, follows the same\npath.\n\nIn the clearing, Valdeterre waits for his opponent. Someone walks\ntowards him. Valdeterre is looking down and has a vision of the Chevalier\nde La Roche xx as he has known him. But a youthful, fresh voice greets him\nand startles him. Before him stands a golden haired, blue-eyed, merry-\nfaced boy. Startled Valdeterre wants to know what this means; he came to\nfight a man, and this man the best swordsman in the colonies, not a mere\nboy. The boy replies: "Softly, Monsieur, you have before you the only and\nlegitimate Chevalier de la Roche..." and explains that the Chevalier, his\nfather has died an honorable death on the battlefield.\n\nValdeterre is gravely disappointed and at first refuses to fight\nwith the mere boy. But gauded on and teased beyond endurance by the boy's\nsarcasm, he finally sees himself forced to accept the challenge.\n\nIn the course of the duel which from mere sword's play has grown\ninto a bitter struggle, the "boy" proving himself a much better swordsman\nthan Valdeterre expected, Valdeterre suddenly feels faint. It seems to\nhim that the Chevalier de La Roche is fighting by the side of his heir,\nholding and guiding the latter's hand. Valdeterre's faintness grows till\nhe finally falls on the ground in a swoon.\n\nDominique who, from a distance, has watched the duel and its out-\ncome, rushes in, ascertains that Valdeterre is not dead but has merely\nfainted and helps to carry him into the La Roche mansion.\n\nBy means of a medicine, the secret of which is known by Dominique,\nValdeterre is revived and soon realizes where he is. Horrified at being\nforced to accept the hospitality of his hereditary enemy, Valdeterre leaves\nas quickly as he is able to. His feelings are a mixture of hatred, sorrow\nand admiration for the golden-haired boy who fought so bravely against him.
s1229l11157	5	-4-\n\nAt the end of the ball, the governor mentions the name of Valdeterre\nto Diane. Proudly Diane replies that: "The Vicomte de Valdeterre is the hered-\nitary enemy of our house" and that he is moreover "a most disagreeable person"\nthen leaves.\n\nThrough the message he has just received, Valdeterre learns that\nValcour de la Roche, the "Little Chevalier" has been called to the interior on\nurgent business but that, should Valdeterre still find himself desirous of again\nentering his garden, he, Valcour, shall be most happy to entertain him there on\nhis return.\n\nValdeterre sends Dominique back with a reply stating that his, Valdeterre\nlongings to again gaze upon the beauty of the garden in question are hardly to be\nrestrained, and begging the chevalier to shorten his absence as much as possible.\n\nIn spite of this fine challenge, Valdeterre realizes more and more that\nhe has fallen thoroughly in love with Diane and that he cannot help but admire\nthe little Chevalier's pluck.\n\nValdeterre has been empowered through the King's written order to seize\nthe La Roche property but decides not to do so: "Let the red-haired boy and the\nfair-faced girl keep their father's unlawful gains!"\n\nAt a public game given by the Governor, Valdeterre, Diane and Delaup\nare once more thrown together. The game consists in shooting at a wooden duck.\nThe best shot is to earn a prize. Valdeterre is a remarkable shot, but the pres-\nence of Diane and her supposed indifference and coldness cause him to lose his\nnerve. He does not hit the mark. Delaup wins the prize. Diane shouts: "Bravo,\nMonsieur Delaup! Bravo and thanks! Louisiana against France! Victory!"\n(The contest was close between Delaup and Valdeterre). The governor is shocked\nand reprovingly remarks: "Treason, Mademoiselle, treason". But Diane, still more\nincisive, adds: "And the sooner Monsieur reports my treason to His Majesty, the\nbetter." But Valdeterre only bows to the governor: "Your excellency, beauty can\nutter no treason. France, on occasion, knows how to be deaf and when to be dumb"\nand walks away. Delaup is awarded the prize. Diane watches Valdeterre, walking\naway, then, impulsively runs after him and stops him: "...If your father died\nby the hand of mine, my father died, because of yours, in exile. You who are a\nman and free, why do you stoop to hate me who am but a woman?...I, at least, have\nnever harmed you...Why do you hate me, Monsieur de Valdeterre.\n\nValdeterre, taken aback, astonished, cannot for the time, reply. Once\nmore Delaup steps in and calls Diane back to the game. Once more, she proudly\nwalks away from Valdeterre and joins Delaup. Delaup warns her against Valdeterre.\nHe knows something which he does not care to disclose.\n\nBefore a miniature of his father, Valdeterre, back at his hotel, stands\nin utter despair: "Oh, my father, if you could have but known how beautiful she is!"\nValdeterre takes the miniature in hand. As he presses the frame firmly, the back\ndrops off, disclosing an old, faded and discolored parchment which had been in-\nserted between the frame and the back of the picture. This proves to be a marriage\ncontract between himself and Diane, passed between their respective fathers in their\ndays of close friendship. The contract mentions that "if any difference should\narise between the two houses of Valdeterre and La Roche, it will in no way effect
s1229l11157	8	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l17208	1	"FOR YOUR DAUGHTER'S SAKE"\n© CIL 17208\n\nIn the maelstrom of the frenzied finance of Wall Street,\nFrederick Searles, at sixty, finds himself dashed against the rocks of\nbankruptcy. Even the home in which he and his family live groans beneath\nthe weight of mortgages.\n\nTo the defeated financier and his wife whose horizon is bounded\nby the dollar sign, there is but one way out of their difficulty -- to\nsell their daughter to the highest bidder in that approved modern fashion,\nthe marriage market. Needa, the older of their two daughters, flower-like\nin her beauty, has reached the marriageable age, and to the calculating\neye of the mother is eminently fit for the auction block.\n\nThat Needa loves a man who is steadily climbing to success that\nhe may soon be able to claim the girl he loves as his wife, is to the\nmother an irritating matter to be dismissed promptly and with finality.\nFor just such an emergency, as Mrs. Searles considered it, she had\ncarefully prepared to cope. Into her daughter's mind she had instilled\na sense of obligation to her parents; of unquestioning conformity to\ntheir desires.\n\nThe highest bidder comes. John Davis Warren looms a power in\nWall Street. Surfeited with the pleasures that money could buy, and\nfinding the life he had been leading beginning to pall upon him, Warren\nsees Needa's beauty with a quickening of the pulses. With the confidence\nthat wealth inspires, he bids for the girl's hand.\n\nCoerced by her parents, Needa passively agrees to the marriage\nand resigns her hope of happiness with Hugh Stanton, the man she loves.\n\nNeeda and Mr. Warren are married and leave immediately on\nMr. Warren's yacht for a honeymoon cruise. On that same day Hugh Stanton
s1229l17208	2	- 2 -\n\nsails to take up the work of salvaging some ships that have been\ntorpedoed.\n\nDays pass, grey and loveless and foreboding. Stung by his wife's\ncold passivity and by his utter failure to awaken in her any spark of\nlove, Warren, driven to brutality by drink, forces his way into Needs's\nstateroom.\n\nJust then Hugh Stanton, wrecked at sea and who for three days\nhad been floating in a life-boat, almost lifeless, is taken aboard the\nyacht. He hears Needs's cry for help and recognising the voice, makes\na desperate effort to go to her aid.\n\nThe next day, and the one following, Needs and Hugh spend quiet,\nhappy hours together, thinking not of the past nor of the cheerlessness\nof the future, but merely living in the pensive contentment of the\npresent, in the pleasure of seeing and talking with each other again.\nFor Needs, the future holds forth nothing but the duty she owes to the\nman she has married.\n\nBack in New York, Warren endeavors to break his relations with the\nwoman he had known before his marriage. He tells her he expects to\nbecome a father. The woman, suppressing her anger and jealousy,\nsmilingly insinuates that he may not be the father of the expected child.\nHugh Stanton, she informs him, is Needs's lover. They were together on\nthe yacht and so --. She smiles as she sees her subtle poison take effect.\n\nNearly crazed with suspicion, Warren accuses his wife of\ninfidelity and brutally strikes her. The sight of Hugh Stanton leaving\nthe house as he was returning had strengthened his suspicions and made\nhim brutal. In the days that follow Needs wavers between life and death.\nHer child is born - dead. With little left to live for, her recovery is\nslow.
s1229l17208	3	- 3 -\n\nShe leaves her husband and refusing to return to the parents\nwho had sold her, seeks work by which she can support herself. It is to\nHugh Stanton to whom she goes for advice. He only link with her family\nis her sister Ethel whom she had saved from a marriage as fatal as her own.\n\nAll Mr. Warren's attempts at a reconciliation prove futile.\nReturning to the woman he has discarded, he threatens her for having\npoisoned his mind against his wife, as a result of which he has lost her.\nHe wants to break all relations with the woman and offers her money.\nShe tells him she loves him but he is obdurate to her pleadings. In\npassionate rage, she shoots and kills him.\n\nFree once more, to Beeda and Hugh comes the happiness that\nthe avarice of the misguided parents had denied them.
s1229l17208	4	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229m02420	2	© CLM 2420\nJAN 26 '24 / ANIMAL ATHLETES /\n\n1.(7) The human race has no copyright on the instinct\nfor sport or play;\n\n2.(6) Every four-footed entry has the same age-old\ninstinct.\n\n3.(5) A puppy and a kid are nature's greatest mates.\n4.(8) Their competition is older than that of Yale and\nHarvard by a thousand years.\n\n5.(6) The deer, Paddock of the woods, also figures in sport --\n6.(6) But unfortunately he is on the wrong end of the gun.\n\n7.(8) The African Gnu, although caged, must have his morning\nwork-out.\nBronx-Zoo, N.Y.C.\n8.(5) His face may be silly but his feet are fast.\n\n9.(4) Gnu stuff.-\n\n10.(6) The bear is the original play boy of the Western world.\n\n11.(7) In the zoo he quits playing to see what makes the\ncamera click.\n\n13.(10) But two young giants lately captured in the wilds,\nstart training for water polo.\nPincher Creek, Alberta\n\n13.(8) After the work-out they use Henri Reviere, famous\nguide as the training table.\n\n14.(6) What would polo be without the pony?\nHeadow Brook Club, L.I.\n\n15.(4) Putting on the shin guards for battle.\n\n16.(9) They love the game as much as the riders, and\ntake the field with the same spirit.\n\n17.(5) Even the grim police dog demands his play time.\n\n18.(4) Football is his favorite pastime.\n\n19.(4) A novelty in cat-fishing.\n\n20.(3) Play at both ends of the line.\n\n21.(3) And the horse is at least 75 per cent of the steeple-\nchase.\n\n23.(10) At the brilliant Rose Tree Hunt the crowd finds\nhim more important than the rider.\n\n23.(5) There's an equine thrill at every barrier.\n\n24.(5) He also knows the strain in the stretch. (Change of title)
s1229m02420	1	Form 284 11-23 500\n\nTitle of Motion Picture\n\nAnimal Athletes\n\nProduced and Manufactured by\nPATHE EXCHANGE, Inc.\nNEW YORK, N. Y.\n\nCopyrighted
s1229m02420	4	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229m02420	3	ANIMAL ATHLETES\n\n25.(5) You may not think of the fur seal as an athlete.\n\n26.(5) But how many humans can dive OUT of the water?\n\n27.(6) Seals have their swimming meets about nine times a day.\n\n27*(4) They are the Johnny Weissmullers of the surf.\n\n28.(6) After all, the dog's favorite sport is chasing a stick.\n\n29.(10) C.F.Peter's great collie, "Sandy", holds the world's record as a stick retriever.\n\n30.(4) The slow motion shimmy -\n\n31.(5) "Just once more" -\n\n32.(7) This sport for him has football, baseball and golf licked to a frazzle.\n\n33.(4) Punching the bag is another popular dish.\n\n34.(5) The bag in this case happens to be a balloon.\n\n35.(5) The nose lands the punch instead of taking it.\n\n36.(6) Here is perfection of rhythm, grace and beauty in action.\n\n37.(5) "I could do this all day - "\n\n38.(15) The four-footed animal helps to prove that sport and play are among the oldest instincts of the living breed, dating back beyond all times.\n\n39.(5) The End.\n\n* * * * *
s1229m01403	2	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l17205	6	THE LADY FROM LONJACHES\nREEL 2\n\n169 Blue\nExt. cu man looks\n170\n" Ext. cu Princess and Russell talk\n8.2.63\n" Thank you\n171\n" Ext. cu Princess and Russell talk\n172\nExt. " Ext. cu man by wall\n173\n" Ext. cu Princess\n174\n" Ext. cu Princess and Russell\n175\n" Ext. cu man\n176\n" Ext. street cu Russell\n177\n" Ext. " cu man exits\n178\n" Ext. " Russell by auto - man enters\n179\n" Int. auto cu Princess\n180\n" Ext. cu Russell and man\n8.2.64\n" She's run\n181\n" Ext. cu Russell and man talk\n182\n" Int. auto cu Princess\n8.2.65\n" No! No! Please\n183\n" Ext. cu Russell and man talk\n184\n" Int. auto cu Princess\n185\n" Ext. Russell and man talk\n8.2.66\n" You heard\n186\n" Ext. Russell and man - man gets pushed\n187\n" Ext. street man lands on ground\n188\n" Ext. " Russell by auto\n189\n" Ext. " cu Russell\n190\n" Int. auto cu Princess\n8.2.67\n" No! No!\n191\n" Int. auto cu Princess\n192\n" Ext. cu Russell\n193\n" Ext. street man gets up\n194\n" Ext. Russell by auto\n195\n" Ext. street man gets up - exits\n196\n" Ext. auto exits - man jumps on\n197\n" Ext. man on car fights with Russell\n198\n" Ext. street auto enters - man falls off\n199\n" Int. auto cu Russell and Princess\n200\n" Ext. street man gets up\n201\n" Int. auto cu Russell and Princess\n202\n" Ext. street man on\n203\n" Int. auto cu Russell and Princess\n8.2.68\n" Won't you tell\n204\n" Int. auto cu Russell and Princess talk\n8.2.69\n" I thank you\n205\n" Int. auto cu Russell and Princess\n8.2.70\n" Oh, I beg your\n206\n" Int. auto cu Russell and Princess\n8.2.71\n" It's rather late\n207\n" Int. auto cu Russell and Princess talk - fade\n8.2.72 Amber\n208\n" Lord Charles\n" Fade in Int. room Lord and wife talk\n209\n" Int. hall Russell and Princess enter\n210\n" Int. room cu Lord and wife\n211\n" Int. hall cu Russell and Princess\n212\n" Int. room Lord and wife\n213\n" Int. hall Russell and Princess\n214\n" Int. room Russell and people on\n215\n" Int. " cu Russell and Princess\n8.2.73\n" When we wish
s1229m01403	1	© CLM 1403\n\nNew Screen Magazine, No. 28-\nOne Reel\n\nMONORAILROADS are scarce. New\nScreen Magazine, No. 28, shows\none of the few. It is located in Bally-\nbunion, Ireland, and is only one of the\npicturesque features of the Killarney\nLake region. By aid of a remarkable\ncartoon we are shown what most peo-\nple never even imagined existed—an\naunt dairy. It is also difficult to be-\nlieve that five hats can be made for a\ndollar, but they can. Lillian Russell\nshows you how smiles increase your\nbeauty, while Sig. Falconi shows you\nhow to read your lover’s character.\nWhile old Dad Watson, the eighty-\nyear-old bear hunter of the Cumber-\nland Mountains, is showing you how\nyoung he is our own parlor chemist\nshows you how to make ordinary win-\ndow glass. There is also a futurist\nportrait of James J. Corbett, Univer-\nsal star.\n\nAUG 25 1919 √
s1229l18102	5	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l18102	2	AUG -2 1922\n\n©CIL 18102  IN THE DAYS OF BUFFALO BILL\nPhotoplay in two reels\nEpisode 1 "Bonds of Steel"\nStory and scenario by Robert Dillon\nDirected by Edward Laemmle\nAuthor of photoplay (under Sec. 62)\nUniversal Film Mfg. Co., Inc. of the U. S.
s1229l18102	4	AUG -2 1922\nWashington, D. C.\nRegister of Copyrights,\nLibrary of Congress,\nWashington, D. C.\nAugust 2, 1922\n\nI herewith respectfully request the return of the following named motion picture films deposited by me for registration of copyright in the name of\nUniversal Film Mfg. Co. Inc.\n\nTHE STORM (8 reels)\nIN THE DAYS OF BUFFALO BILL No. 1 (2 reels)\n\n31660 AUG-2'22\nRespectfully,\nFULTON BRYLAWSKI\n\nThe Universal Film Mfg. Co. Inc.\nhereby acknowledges the receipt of two copies each of the motion\npicture films deposited and registered in the Copyright\nOffice as follows:\n\nTitle           Date of deposit     Registration\nTHE STORM       8/2/1922             L ©CIL 18101\nDAYS OF BUFFALO BILL No. 1     "             L ©CIL 18102\n\n31660 AUG-2'22\n\nThe return of the above copies was requested by the said\ncompany, by its agent and attorney, on the 2 day\nof August and the said Fulton Brylawski for\nhimself and as the duly authorized agent and attorney of\nthe said company, hereby acknowledges the delivery to him\nof said copies and the receipt thereof.\n\n2° Copy Returned\nApr 4 1922\nDorson\n[Signature: "Dorson Dorson"]\n\n[Handwritten note: "Dorson Dorson"]
s1229l18102	1	AUG -2 1922\n\n© CIL 18102\n\nIN THE DAYS OF BUFFALO BILL".\n\nALDEN CARTER...........GEORGE A. WILLIAMS\nALICE CARTER...........DOROTHY WOODS\nART TAYLOR.............ART ACORD\nBUFFALO BILL CODY......DUKE EKK R. LEE\nLAMBERTASHLEY..........J. MORLEY\nALDEN CARTER...........OTTO NELSON\nGASPARD.................PET HARMON\nQUANTRAL................JIM COREY\nALLAN PINKERTON........BURTON C. LAW\nEDWARD M. STANTON......WM. P. DEVAUEL\nWM. H. SEWARD...........CHARLES COLBY\nGIDEON WELLS...........JOE HAZELTON\nMONTGOMERY BALIR.......G. B. PHILIPS\nABRAHAM LINCOLN........JOE L DAY\nTHOS. C. DURENT........CLARK COMSTOCK\nGENERAL HANCOCK........BURT FRANK.
s1229l18102	3	SYNOPSIS\n"IN THE DAYS OF BUFFALO BILL"\nEPISODE ONE.\nAUG -2 1922\n\nCalvert Carter, a southern veteran of Civil War is entering the\ngreat west beyond the Mississippi, by prairie schooner, to find\na new home for himself and daughter, Alice. They are attacked\nby Indians and flee. They take refuge in an abandoned shack. This\nis all observed by Art Taylor, pony express rider, and Bill &and\nCody, later famous as Buffalo Bill. Art asks Cody to take his\ndispatches to Fort Kearney, Neb., and goes to help the Carters.\nCody arrives at the fort and starts away with military help for\nCarter. Art gets into the shack with the Carters. Indians ignite\nthe house by rolling in burning wagon wheels. To save the girl,\nArt offers himself as a living sacrifice, leaving his gun and\ntelling Alice and her father to use is suicidally if the worst\ncomes to worst. Outside, Art, hands down offers himself. The\nIndians close in on him but Cody and the soldiers arrive and the\nIndians scatter. The Carters, saved, are thankful to Art. The fire &\nput out by soldiers.\n\nAlice and her father have made a home of the abandoned shack.\nIn the East, at this time, the offices of General Granville M.\nDodge, chief engineer of the U.P., are entered at night by two separate sets of intruders, one a lone emissary of a foreign power,\nanxious to keep America divide. The other a trio of shadowy figures\nThey discover the emissary while searching the office for\nplans. He covers them but they knock out the light and flee. Back\nWest, Art Tayloy is presenting Alice with a wild pony which he has\ncaught and tamed. Lamber Ashley, the agent of the mysterious eastern\ninterest, appears in the west to buy the site of the proposed rail-\nroad junction, as set forth in the plans examined by the mysterious\ntrio in General Dodge's office. The Carter house is on this\nsite. Ashley offers Carter $25,000 for his\nland. Taylor advises Carter not to sell. Carter refuses to sell.\nAshley, sore, goes away.\n\nBack East Thomas C. Durant, chief contractor and vice-president of the Union Pacific Railroad, gets a bribe of half a million\ndollars from the three strangers to delay construction for six\nmonths. He refuses and they warn him of their power and depart. Durant\norders work to star. Work starts on the railroad. Art and\nAlice are now good friends. The three strangers decide they must\nhave the Carter land at any cost.\n\n# # # #
s1229l17205	4	THE LADY FROM LONGACRE\nREEL # 1\n\n83     B.W.     Int. room     on Charles\n84     "        Int.          on Laura\n85     "        Int.          Russell and Aunt on\n86     S. T. 37  "            But why are you\n86     "        Int. room     Russell and Aunt on\n87     Ins. 38   "            Paper: Another wild party\n87     "        Int. room     Russell and Aunt on\n88     "        Int.          man and Tiger enter\n89     S. T. 39  "            I say James\n89     "        Int. room     Tiger and James on\n90     "        Int.          Russell and Aunt on\n91     S. T. 40  "            Ridiculous! Just a\n91     "        Int. room     Russell, Aunt, Laura and Charles on\n92     "        Int.          James and Tiger on\n93     "        Int.          Russell and Aunt on - James enters\n94     S. T. 42  "            Mister Tiger Bugg\n94     "        Int. room     James, Russell and Aunt on\n95     "        Int.          Tiger on\n96     "        Int.          Russell and Aunt on - he exits\n97     "        Int.          Tiger on - Russell enters\n98     S. T. 42  "            It's Molly Gov'nor\n98     "        Int. room     Russell and Tiger on\n99     "        Int.          Charles, Aunt and Laura on\n100    S. T. 43  "            So he never\n100    "        Int. room     Charles, Aunt and Laura\n101    "        Int.          Tiger and Russell on - exit\n102    S. T. 44  "            Just a misunderstanding\n103    "        Int. room     Russell, Aunt and Laura and Charles on\n104    "        Int.          Russell and Aunt on - Russell exits - fade\n105    S. T. 45  Pink         At the Savoy\n105    "        Int. room     Fade - Molly on\n106    "        Int.          Molly in bed - maid enters\n107    S. T. 46  "            If it's Sir Anthony\n107    "        Int. room     Molly in bed - maid on\n108    "        Int.          Molly on\n109    "        Int.          Russell enters\n110    "        Int.          Molly on\n111    "        Int.          Russell on - Molly enters\n112    "        Int.          Russell and Molly on\n113    S. T. 47  "            I wanted to see\n113    "        Int. room     Russell and Molly on\n114    "        Int.          Russell and Molly on\n115    "        Int.          on Russell and Molly\n116    Ins. 48   "            Letter: Molly mine : I foresee\n117    "        Int. room     on Russell\n118    "        Int.          on Molly\n119    "        Int.          on Russell\n120    "        Int.          on Molly\n120    "        Int.          on Russell\n\nEND OF REEL ONE
s1229l13275	9	Page 6.\n\nScene 46---BENCH.\nWinnie introduced to Twede. She starts to sit and sits on spur.\nJumps up angry and off.\n\nScene 47---HOUSE.\nWinnie into house.\n\nScene 48---BENCH.\nZeke on and laughs at joke. Twede out with Zeke. Betty off.\n\nSub-title:--TWEDe IS INTRODUCED TO SEVERAL WESTERN SPORTS AND PASTIMES.\n\nScene 49---RACE.\nTwede with large crowd, witnesses race. Twede off after race with Zeke.\n\nScene 50---STREET.\nTwede and Zeke on - Zeke speaks.\n\nSub-title:--"YOU GO AHEAD AND GET YOUR DRINK, TWEDe, I'LL BE WITH YOU SHORTLY."\n\nScene 51---BARN.\nTwede on. Western cowboy on. Septs in puddle of water, splashing Twede. Twede turns and says\n\nSub-title:--"SAY, YOU BIG WESTERN STIFF, IF THERE'S GOING TO BE ANY SPLASHING DONE AROUND HERE, I'LL DO IT. GET ME?"\n\nScene 52---Westerner pulls gun. Shoots Twede's hat off. Twede off. Westerner continues shooting.\n\nScene 53---FIELD.\nTwede on after hat. Hat runs away from him, hit by bullets several times. He gets it, puts the remains on his head. Ducks last shot. Westerner takes out white flag and waves it. Twede out.\n\nScene 54---FIELD.\nBoy standing there. Twede on backwards. Bumps boy. Boy speaks and pulls gun.
s1229l13275	13	Page 10.\n\nSub-title:-- "AND WHEN THE FLAME HITS THE FUSE, YOU'LL BE BLOWN TO ATOMS. HA-\nRA-HA."\n\nScene 79-- -- She rises and asks Twede finally.\n\nSub-title:-- "YOUR LAST CHANCE - THINK! WILL YOU MARRY ME?"\n\nBack to scene.\nHe says "no." She takes pencil and paper and writes note.\n\nNote:-- -- Betty:-\nI have my revenge. In ten minutes, your Twede will be\nshot and his body blown to atoms with Pinto Pete's shack,\nwhere I hope he is regretting his love for you.\n\nWild Cat Winnie.\n\nScene 80-- -- -- She exits leaving Twede tied.\n\nScene 81-- -- -- EXTERIOR SHACK.\nWinnie on to horse and exits.\n\nScene 82-- -- -- ROAD.\nWINNIE ALONG ON HORSE, EXITS.\n\nScene 83-- -- -- HOUSE.\nWinnie on with horse, sees Betty on chair. Throws note on knife.\nIt lands on back of chair. Betty sees, takes note and reads.\n\nScene 84-- -- -- (NOTE) 79-A.\nBetty looks at Wild Cat Winnie. Both register hatred. Betty\nshakes fist. Winnie laughs. Betty says.\n\nb-title:-- -- "YOU MAY BE A WILD CAT, BUT NOW I'M WILDER. LOOK OUT FOR MY CLAWS!"\n\nScene 85-- -- -- HOUSE.\nBetty looks off.
s1229l13275	14	Page 11.\n\nScene 86- - - - - ROAD.\nMan on horse, riding slowly.\n\nScene 87- - - - - HOUSE.\nBetty takes a boot and throws at man on horse.\n\nScene 88- - - - - ROAD.\nMan on, horse, hot, with boot. Falls Betty with flying leap lands on top horse and rides out.\n\nScene 89- - - - - ROAD.\nWinnie sees Betty on horse and off. Betty after her.\n\nScene 90- - - - - ROAD.\nBOTH ALONG, FAST.\n\nScene 91- - - - - ROAD.\nBetty passes Winnie and rides in front of her.\n\nScene 92- - - - - EXTERIOR SHACK.\nTwede looks at gun and at dynamite. Starts to cry. Mouth fills with tears. He spits out tears on to candle putting it out.\n\nScene 93- - - - - ROAD.\nBOTH girls riding fast.\n\nScene 94- - - - - INTERIOR SHACK.\nTwede happy at escape. Speaks.\n\nSub-title: - - - "THAT'S THE FIRST MOUTHFUL OF WATER THAT EVER DID ME ANY GOOD."\n\nScene 95- - - - - INTERIOR SHACK.\nTwede looks at gun and sees. Starts to bite rope.\n\nScene 96- - - - - EXTERIOR SHACK.\nBoth women on. Betty off and to door of shack. Winnie dismounts and to Betty, stopping her. Betty turns to her and says-
s1229l13275	2	JAN 16 1919\n\n"THE - UNDERFOOT."
s1229l13275	4	THE TENDERFOOT.\n\nMain Title:-\nJester Comedy Company\npresents\nTHE TENDERFOOT\nwith\nTWEDR-DAN.\n\nSub-title:-- TWEDR, THE SHOEMAKR MILLIONAIRE, AND HIS VIRTUOUS COUCH.\n\nScene 1 - - - The time - midnight.\nThe couch as usual unoccupied.\n\nScene 2 - - - BEDROOM.\nTwede's room unoccupied.\n\nSub-title:-- WHILE TWEDR TRIES TO START A CHAMPAGNE FLOOD IN "COCKTAIL CANYON,"\nORDINARILY TERMED 'BROADWAY.'\n\nScene 3 - - - Cafe.\nTwede drinking champagne, with two girls. Waiter also on.\n\nSub-title:-- AND HIS POOR OLD DAD.\n\nScene 4 - - - FIREPLACE.\nFather looks at watch - moff.\n\nScene 5 - - - DOOR.\nFather on and off.\n\nScene 6 - - - LIBRARY.\nFather in, writes telegram.\n\nScene 7 - - - CAFE.\nCork of champagne bottle goes in waiter's eye; ice down back of\ngirl; wine into back other girl. Girls off. Twede sees cork-\nscrew, takes and tries to remove cork.\n\nSub-title:-- "WAITER, MY FAVORITE DRINK IS WINE. BUT HERE'S WHERE I TRY MY HAND\nAT AN "EYE BALP."
s1229l13275	16	Page 13.\nduiged too freely in the juice of the grape, the preceding evening,\nwhich we pictured at the start of the story. FADE OUT.\n\nFINIS.
s1229l13275	8	Page 5.\ncene 36- - - FUDGLE.\nTwede falls out of carriage, into puddle, up and off.\nicene 37- - - ROAD.\nZeke laughs at Twede, both talk.\nSub-title:- - "WELL, YOUR DAD ASKED ME TO PUT YOU ALL ON THE WATER WAGON. YOU'VE MET THE WATER, AND HERE'S THE WAGON."\nScene 38- - - ROAD.\nTWEDe in to wagon. Wagon off over bumps into distance.\nScene 39- - - RANCH.\nTwede meets Betty.\nSub-title:- - TWEDe MEETS BETTY, THE APPLE O' ME EYE.\nScene 40- - - RANCH.\nTwede and Betty off, after love scene.\nScene 41- - - PIG. (Love scene)\nTwede and Betty in pig sty. Up and off.\nScene 42- - - BENCH.\nTwede comes in with Betty. Sits down on spur. Betty nearly sits on spur. Both seated - love.\nsub-title:- - "WELL, THIS IS ... TW, A NEIGHBOR OF ZEKE'S.\nScene 43- - - HOUSE.\nWinnie out and stands at door. She sees Twede, registers "likes him."\nScene 44- - - BENCH.\nBetty calls her.\nScene 45- - - HOUSE.\nWinnie off to bench.
s1229l13275	6	Page 3.\nTITLE:— — — — (wire)\nZeko Longhorn,\nBank Bluff, Mont.\nSHIPPING YOU MY FATTED CALF, TWEDe. HE HAS NEARLY\nBROKE ME, NOW, I WANT YOU TO BREAK HIM. YOU'LL\nRECOGNIZE HIM BY A BOOZE BREATH, THAT YOU CAN\nSMELL HALF A MILE.\nHIRAM.\n\nScene 18— — — HALL.\nFather talks to Twede.\n\nSub-title:— — "YOU'RE SO WILD AND WOOZY, A SPELL IN THE WILD AND WOOLY WILL DO\nYOU GOOD. I'VE ARRANGED EVERYTHING."\n\nScene 19— — — HALL.\nFather takes Twede out.\n\nScene 20— — — ROOM.\nTWEDe ON, LAYS DOWN ON BED, FULLS UP COVERS.\n\nSub-title:— — THE NEXT MORNING, TWEDe THOUGHT THE UNION DEPOT WAS A JAIL, BUT\nIT WASN'T.\n\nScene 21— — — STATION.\nTwede in with dad, both out.\n\nScene 22— — — TRAIN.\nFather puts Twede on train.\n\nSub-title:— — HE CAUGHT THE FIVE-FIFTEEN — ALL RIGHT.\n\nScene 23— — — TRAIN.\nTrain off.\n\nSub-title:— — INSTEAD OF A DRINK, HE HAD A COUPLE OF DAY DREAMS.\n\nScene 24 — — TRAIN.\nCU Twede.
s1229l13275	12	Page 9.\n\nScene 73-- -- FIELD.\nWinnie riding with Twede in front of her, on saddle.\n\nScene 73-- -- HOUSE.\nBetty on, father on, and asks if seen Twede. She answers "No."\nFather says he is missing. She talks.\n\nSub-title:-- -- "IT WAS LOVE AT FIRST SIGHT, FATHER. YOU MUST FIND HIM OR DIE."\n\nScene 74-- -- HOUSE.\nFather off to search. Betty still on.\n\nScene 75-- -- EXTERIOR SHACK.\nWinnie on with Twede. Takes Twede into shack.\n\nScene 76-- -- INTERIOR SHACK.\nTwede faints. Winnie throws water in face. He recovers. Winnie speaks.\n\nSub-title:-- -- "NOW, YOU TENDERFOOT, YOU ARE IN MY POWER."\n\nScene 77-- -- INTERIOR SHACK.\nTwede throws her away from him. She runs after him. Gets him up against post and kisses him. He speaks\n\nSub-title:-- -- "I'M BEATEN - OVERPOWERED WITH LOVE."\n\nScene 78-- -- INTERIOR SHACK.\nTwede faints again. Winnie throws more water on him. Asks him to marry her. Twede refuses and tells her he loves Betty. She pulls gun, ties him to post. Takes alarm clock, and fixes on another post with time arrangement attached. She talks pointing to clock.\n\nSub-title:-- -- "WHEN THE CLOCK STRIKES SIX, IT MEANS YOUR DOOM."\n\nBack to scene.\nWinnie takes log of dynamite and candle and arranges fuse and speaks.
s1229l13275	7	Page 4.\n\nScene 25-- - - CU\nGirl in Twede's lap, kissing.\n\nScene 26-- - - TRAIN.\nCU Twede laughing.\n\nScene 27-- - - RANCH.\nTwede on horse, disgusted with Indian woman.\n\nScene 28-- - - TRAIN.\nCU Twede disgusted.\n\nScene 29-- - - RANCH.\nZabette and Zoke get telegram.\n\nScene 30-- - - WIRE.\nSame as scene Twenty-four.\n\nScene 31-- - - RANCH.\nEnds scene 40.\n\nScene 32-- - - PULLMAN.\nTwede on, sees man bump his head, then to berth. Gets his head between two feet, then into berth. Falls out into lady's lower berth. Lady comes on, calls porter. Porter puts him back in his berth.\n\nSub-title:-- - "NOW I KNOWS YOU'LL STAY PUT."\n\nScene 33-- - - PULLMAN.\nPorter closes berth.\n\nSub-title:-- - TWEDS ARRIVES AT BLANK BLUFF.\n\nScene 34-- - - STATION.\nTwede off train, met by Zoke, both off.\n\nScene 35-- - - ROAD.\nBoth into carriage and off.
s1229l13275	15	Page 12.\n\nSub-title:-- -- "SHOW YOUR CLAWS, YOU WILD CAT, I'LL SHOW YOU WHAT A CAT FIGHT\nREALLY IS."\n\nScene 97-- -- -- EXTERIOR SHACK.\nBoth women start a rough and tumble fight.\n\nScene 98-- -- -- INTERIOR SHACK.\nTwede biting cord.\n\nScene 99-- -- -- EXTERIOR SHACK.\nFighting. Both roll out and off.\n\nScene 100-- -- -- CLIFF.\nBoth on and roll to edge. Wimnie over Betty, victorious.\n\nScene 101-- -- -- GULLY.\nFLINT ROLL. Apparently dead.\n\nScene 102-- -- -- CLIFF.\nBETTY up and off to shack.\n\nScene 103-- -- -- INTERIOR SHACK.\nTwede finishes biting. 6 O'clock strikes. Revolver discharged\nover his head. Betty on and takes him in her soft and voluptuous\narms. Twede returns the embrace. Twede then with admirable cour-\nage takes dynamite barrel or keg, and with one mighty effort throws\nit out of the scene.\n\nScene 104-- -- -- GULLY.\nKeg of dynamite falls where Wimnie is resting and explodes with\nresults that can be imagined better than described.\n\nScene 105-- -- -- INTERIOR SHACK.\nClose-up of Betty and Twede kissing, passionately and fondly. Fade\nout.\n\nScene 106-- -- -- ROOM.\nFade in. Twede madly kissing a soft and voluptuous pillow. He\nfondles it with manly grace and suddenly realizes that he had in-
s1229l13275	3	©CIL 13275\nJAN 16 1919
s1229l13275	5	Page 2.\n\nScene 8 - - - CAFE.\nTwede continues to remove cork. Puts foot through wall.\n\nScene 9 - - - KITCHEN.\nCook on. Twede's foot hits cook in the face. Cook pushes his foot out.\n\nScene 10 - - - CAFE.\nTwede flies out.\n\nScene 11 - - - STREET.\nTwede flies on and dresses with coat and hat. Trick off.\n\nSub-title: - TWEDe WAS CONVINCED THAT IT WAS A DUSTY NIGHT ON THE OCEAN.\n\nScene 12 - - - STREET.\nTwede rocking along street, intoxicated.\n\nSub-title: - SOMEBODY CERTAINLY WAS ROCKING THE BOAT.\n\nScene 13 - - - STREET.\nTwede to lamp post. Cop on, and picks him up. Both out.\n\nScene 14 - - - STREET.\nTwede along. Cop on and picks him up. Puts bricks in pocket.\nTwede off.\n\nScene 15 - - - LIBRARY.\nFather hears Twede - out.\n\nScene 16 - - - EXTERIOR DOOR.\nTwede on, and in.\n\nScene 17 - - - HALL.\nTwede on to dad. Dad shows wire.
s1229l13275	1	L13275
s1229l13275	10	Page 7.\n\n1b-title:-- - "LOOK'Y HERE, MISTER! DON'T YOU STEP ON ME. I MAY BE SMALL, BUT\nI'M NASTY AS H--1."\n\ncene 55-- - - FIELD.\nTwede turns and looks at boy and runs away.\n\nub-title:-- - - SPURRED AND SPURNED, WILD CAT WINNIE WAITS AND PRACTICES.\n\ncene 56-- - - HOUSE.\nWinnie sees Twede coming. Tames cigar and starts to smoke. Twede\non and trips over her legs. Twede up, smoke in face. Twede off,\nafter.\n\nsub-title:-- - - "I'M WILD AND WOOLY, BUT I'VE GOT A HEART. I LO-O-OVE YOU! HARD."\n\ncene 57-- - - HOUSE.\nWinnie misses Twede into house.\n\nScene 58-- - - EXTERIOR SALOON.\nTwede runs on, backwards, bumps into Westerner. Falls. Westerner\nthrows Twede into saloon.\n\nScene 59-- - - SALOON.\nTwede flies in and up on to steer's horns. Trick. Hangs there.\nCrowd of ranchers guy him. He hangs and speaks.\n\nSub-title:-- - - "I MAY BE FUNNY, BUT I'M ALSO FLUISH. I'LL BUY."\n\nScene 60-- - - SALOON.\nWesterners take Twede down, minus one coat-tail. Stand him in\ncenter of group and start to shout saying\n\nSub-title:-- - - "YOUR TAIL FEATHER'S PLUCKED NOW, AND THEY WON'T INTERFERE. DANCE\nYOU SOON OF A GUN! DANCE!!"\n\nScene 61-- - - SALOON.\nPut Mexican hat on Twede. He starts to do the Can-Can.
s1229l13275	11	Page 8.\n\nScene 62- - - HOUSE.\nWinnie comes out in new costume.\n\nSub-title:- - REVENGE FOR THE REDUFF. A KIDNAPPER - BY GAR.\n\nScene 63- - - HOUSE.\nWinnie mounts horse and off.\n\nScene 64- - - SALOON.\nWinnie on and dismounts.\n\nScene 65- - - SALOON - INTERIOR.\nWinnie into saloon, shoots out lamps. Picks up Twede and goes out.\n\nScene 66- - - SALOON - EXTERIOR.\nTwede throws Winnie into water, runs away. Winnie watches him, and mounts horse with him.\n\nScene 67- - - FIELD.\nTwede again running. Winnie lassoes him. Pulls him up on horse, and rides out with him.\n\nScene 68- - - SALOON.\nSheriff on and in.\n\nScene 69- - - SALOON.\nSheriff in and is shot at backs out.\n\nScene 70- - - SALOON -\nSheriff goes to door and speaks.\n\nSub-title:- - "HEY, YOU BAR'NIN COYOTES, I'M THE SHERIFF! TWEDe IN THERE?"\n\nScene 71- - - SALOON.\nSheriff in and is told Twede has gone. He out.
s1229l13275	17	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l11391	3	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l11391	1	L / 11, 3 9 /
s1229l11391	2	“ Their Compact”\n\nA 7-Act Metro Super-Feature of a Man Who Kept His Word; Presented by Metro Pictures Corporation; Adapted for the screen by Albert Shelby Le Vino from the original story by Charles A. Logue; Directed by Edwin Carewe; Photographed by R. J. Bergquist; Produced under the Personal Supervision of Maxwell Karger.\nSEP 13 1917\n\nCAST\nJAMES VAN DYKE MOORE\nFRANCIS X. BUSHMAN\nMollie Anderson…………Beverly Bayne\n“Ace High” Horton……Harry S. Northrup\nRobert Forrest ………Henry Mortimer\nVerda Forrest …………Mildred Adams\n“Pop” Anderson………Robert Chandler\nPeters …………………John Smiley\n“Pay Dirt” Thompson…Thomas Delmar\n\nTHE STORY\nJAMES VAN DYKE MOORE goes West to forget the havoc an evil woman has wrought in his life. A silver mine has been bequeathed to him by his father, and he begins to operate it. “Ace-High” Horton has been stealing ore from the mine. In bringing the camp bully to task, Moore attracts the favorable notice of pretty Mollie Anderson. In the night-battle which ensues for possession of the mine, Mollie warns Moore and then saves him from the hands of the desperate bullies whom Horton has employed. Moore is wounded. On his recovery he thanks Mollie for what she has done for him. He tries to believe that gratitude actuates him but knows in his heart that the feeling is a deeper one.\n\nMoore’s friend Robert Forrest brings his bride from the East, and Moore is horrified to learn that the woman he came West to forget is now the wife of his best friend. Verda Forrest begs Moore to keep her secret, and in a moment of weakness, he consent.\n\nForrest goes away to inspect various mines. He decides not to take his wife nor to leave her alone, and asks Moore to protect her while he is away. Moore reluctantly agrees, and the two men shake hands as a token of their compact. Verda and “Ace-High” Horton meet often. She has just agreed to run away with him when her husband returns. She tells him she is running away to escape the attentions of Moore, and that he annoyed her in the East.\n\nForrest asks Moore one question: “Did you know my wife in New York?” Moore’s hesitating answer is interpreted as an evidence of guilt, and Forrest strikes him. Moore holds himself in check. His former friend, seeing in his restraint only the cowardice of guilt, gives him until sundown to leave town. That night, Verda and Horton steal quietly out of the hotel, only to run into Forrest. Thinking the husband knows all, Horton shoots him from ambush. Moore is suspected, and captured by the sheriff’s posse, is led away to pay the penalty of a crime he did not commit.\n\nTrouble awaits the two fugitives on the desert. Horton, realizing that both cannot be saved, determines to sacrifice the woman to save his own life, but Verda forestalls him. She wrests Horton’s pistol from him, shoots him, and then sinks half-crazed into the sands. There Moore, who has been saved by the timely interference of Mollie, finds her and takes her back to make easier the last moments of her husband. He still believes in her.\n\nWhen Moore’s innocence has been thoroughly established, Verda is escorted by the citizens to the edge of the desert, and her horse’s head turned toward the East. Her baneful influence is removed forever from the lives of Moore and Mollie, and together they face a future filled with love and happiness.
s1229l06541	1	< 6 5 4 1
s1229l06541	2	METRO PICTURES\nCORPORATION\nMETRO\nPICTURES\nMETRO\nPICTURES\nPOPULAR PLAYS & PLAXERS\nPresent\nThe EMINENT DRAMATIC\nACTOR\nEdmund Breese\nIN A 5 PART PICTURIZATION\n"The Song Of\nThe Wage Slave"\nFROM THE "SPELL OF THE YUKON"\nAND OTHER VERSES by\nROBERT W. SERVICE,\nBARSE & HOPKINS, Publishers, NEW YORK CITY\nDISTRIBUTED BY METRO PICTURES CORPORATION
s1229l06541	5	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l06541	4	OCT -5 1915 √\n\nMETRO PICTURES\nCORPORATION\n\n© CIL 6541 √\nCAST OF\n\n“THE SONG OF THE\nWAGE SLAVE”\n\nNED LANE....................EDMUND BREESE\nMildred Hale................Helen Martin\nAndrew Hale................J. Byrnes\nFrank Dawson..............Fraunie Fraunholz\nEdwin Dawson..............Albert Froom\nRev. Francis Pettibone....George MacIntyre\nTalek .......................Wallace Scott\nMrs. Talek..................Mabel Wright\nNeda .......................Claire Hillier\nAlice .......................Kitty Reichert\nSims, an agitator..........William Morse\n\nNed Lane, a worker in a great paper mill and a man of\nunusual strength and nobility of character, loves Mildred Hale,\na poor girl, whose father is employed in the same mill. His love\nis not returned, however, for Mildred has already lost her heart\nto Frank Dawson, the dashing young son of the millionaire\nmanufacturer, who owns the mill.\n\nThrough the machinations of Frank's father the match is\nbroken off, and Frank is sent away. Mildred's honor is com-\npromised and Ned, in a spirit of generosity and because of his\ngreat love for her, offers to marry her to save her name and\nreputation.\n\nSoon after the marriage, Frank's father is killed in an ac-\ncident. Frank becomes his own master and, knowing nothing\nof Mildred's marriage to Ned, returns to fulfill his duty by giv-\ning her his name. When Ned learns of this, realizing that\nMildred can never love him and that Frank Dawson should be\nher lawful husband, he decides to disappear in order that she\nmay be free to wed again. He vanishes and arranges it so that\nhe is believed to be dead.\n\nAfter roughing it in various parts of the world, ceaselessly\nworking and creating wealth for others, Ned finally becomes\na leader of an association of mill hands. The organization is\nstrongest in a large paper mill, controlled by the paper trust,\nthe invisible head of which is Frank Dawson, a fact which\nNed does not know.\n\nLabor difficulties become acute, chiefly engineered by Ned,\nwho seeks to serve the cause of labor, to which he has devoted\nhis life. After a series of intense situations, Frank, Mildred\nand Ned are brought face to face. Mildred is driven to despera-\ntion, and the others to despair. Finally to save Mildred's life,\nNed sacrifices his own.\n\nDISTRIBUTED BY METRO PICTURES CORPORATION
s1229l06541	3	NED DECLARES HIS\nLOVE FOR MILDRED\n\n"YOU MUST NOT —\nI AM NED LANE'S WIFE"\n\nMETRO\nPICTURES\n\nMILDRED'S MADDENED FATHER\nSEEKS VENGEANCE ON THE ELDER DAWSON\n\nFRANK IS HAUNTED BY\nMILDRED'S ACCUSING EYES\n\nFRANK COMES TO TELL\nMILDRED OF NED'S DEATH\n\nOLD HALE GRIMLY LIFTED\nMILDRED'S FAINTING FORM
s1229l16934	3	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l16934	2	32128 SEP-6'21\nSEP 6 1921\nREQUEST FOR RETURN OF COPYRIGHT DEPOSITS\nDated at. Wank DB ZP 16934\nSept 6, 1921\n\nRegister of Copyrights,\nLibrary of Congress,\nWashington, D. C.\n\nDear Sir:\n\nThe undersigned claimant of copyright in the work herein named,\ndeposited in the Copyright Office and duly registered for copyright pro-\ntection, requests the return to him under the provisions of sections 59 and\n60 of the Act of March 4, 1909, of one or both of the deposited copies of the\n2 Prints entitled\nThe Old Colon 2 rubs\ndeposited in the Copyright Office on and registered\nunder Class XXc., No. ©CIL 16934.\n\nIf this request can be granted you are asked and authorized to send\nthe said copy or copies to me at the following address:\nor\nto\nat\n\nSigned. Annoisales Fair Nat Film\n(Claimant of Copyright) Co.\n\nCopies Returned\nSEP 14 1921\nBk. D. L. P. L. L.\n\nSEP -7 1921\n\nA. Ex.-P. S. P. P.
s1229l16934	1	SEP -6 1921 √\n\nCOPYRIGHTED BY CHARLES CHAPLIN\n\n©CIL 16934 C\nCHARLES CHAPLIN\nin\n"THE IDLE CLASS"\n2 Reels\nWritten and Directed\nby\nCharles Chaplin\nA First National (T.M.) Attraction. Author of the U.S. √\n\nCAST\n\nThe Tramp\nThe Absent-Minded Husband\nHis Wife\nThe Angry Father\nCharles Chaplin\nEdna Purviance\nMack Swain.\n\nSYNOPSIS\n\nNote — This is a stunt picture. The synopsis means little, but runs somewhat as follows:\n\nTo the exclusive railway station of any exclusive community comes the WIFE, attended by maids and porters as befits her position and consequence. To her obvious disappointment, no one meets her. As she goes to her waiting limousine another passenger from the Limited appears, the TRAMP, who dismounts from beneath one of the coaches, calmly adjusts his luggage which includes a bag of golf sticks, and reaches the WIFE'S automobile in time to ride off in style with her — on the bumper in the rear of the car.\n\nThe ABSENT-MINDED HUSBAND, at the hotel has been preparing to meet his WIFE, but some thirty minutes late. Various mishaps delay him still further and when the WIFE arrives and is shown to her husband's suite she finds it empty till a bounding object darts through and lands sitting up in bed. Such a reception determines the WIFE to occupy other rooms, and she departs with her maids. But she sends her HUSBAND a note that speaks of forgiveness if he will go to the ball masque at the hotel that evening.\n\nMeanwhile, the TRAMP has found his way to the golf course adjoining the hotel and gets into various difficulties that only good luck and fast feet help him out of. During his game he meets the WIFE, who has gone out on horseback to forget her husband's outrageous conduct, and he falls into a day-dream in which vision after vision comes to him until he wakes to the realization that he is still but a lonely tramp. In the most innocent way in the world, he gets into an embarrassing situation with the police, and his endeavors to escape lead him at the ball masque in the hotel, where the WIFE takes him for her husband. The TRAMP does not know what it is all about but thinks his dream is coming true and enjoys himself. Then the ABSENT-MINDED HUSBAND himself, unrecognizable in a suit of mediaeval armor, appears on the scene, becomes furiously jealous and starts a fight. The ANGRY FATHER takes a hand in the fray, and after many complications discovers that the TRAMP is not his son-in-law but that the man in the armor is, and the identification is complete when the TRAMP comes to the rescue and assists in removing the HUSBAND'S helmet.\n\n2 reels
s1229m00714	3	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229m00714	1	M 714
s1229m00714	2	Released September 6th. 1916.\n© CLM 714 CANIMATED NOOZ PICTORIAL NO. 15. 15\nCartoons by Wallace A. Carlson.\nCanimated Nooz camera men film the pleasures of being incarcerated\nat Sing Song, N. Y. The daily reck-pile golf tournament on the prison\ncourse is shown in progress. "Lifer" McNutt's record drive is spoiled\nwhen No. 968 gets his head in the way. Pink tea is served after the\ngame by the Young Ladies' Anti-Cruelty to Animals Society. Luther\nLeatherlungs is caught by the camera as he delivers a speech on "Pre-\nparedness". Dreamy Dud tries a trip in a submarine and blocks all the\ntraffic on the ocean. Five hundred feet of beautiful scenic share the\nreel.
s1229l17205	8	THE LADY FROM LANGACRE\nREEL # 3\n\nS. T. 81 B.W.\n245 " Morning. In the\n246 " Fade in Int. Russell and jeweler\n247 " Int. office on Russell\n248 " Int. " Russell and jeweler talk\n249 " Int. " on jeweler\n250 " Int. " on Russell\n251 " Int. " on jeweler\nS. T. 82 " If you intend\n252 " Int. office on Russell\n253 " Int. " Russell and jeweler\nS. T. 83 " It happens\n254 " Int. office Russell and jeweler talk\n255 " Int. " on Russell\n256 " Int. " Russell and jeweler talk - exit\nS. T. 86 Pink\n256 " And at the\n257 " Ext. cottage L.S. Buck sitting on steps\n258 " Ext. bushes 2 men on\n259 " Ext. cottage S on Buck\n260 " Ext. " Mary looks out of window\n261 " Ext. " Buck gets up - looks up\n262 " Ext. " Mary at window\nS. T. 87 " Good morning\n263 " Ext. cottage Mary at window\n264 " Ext. " Buck on\nS. T. 88 " No, Ma and\n265 " Ext. cottage Buck on\n266 " Ext. " Mary at window\n267 " Ext. " L.S. Buck\n268 " Ext. bushes 2 men on - exit\nS. T. 89 " Do you expect\n269 " Ext. cottage S on Buck and Mary\nS. T. 90 " Yes, Ma and\n270 " Ext. cottage Buck and Mary on - 2 men attack them\n271 B.W. " Int. hall Mary comes on - man after her\n272 " Int. " L.S. man after Mary\n273 Pink " Ext. cottage Buck and man fighting\n274 B.W. " Int. hall woman on - Man enters - knocks her down\n275 " Int. " man on - another enters\n276 " Int. room Mary holding door\n277 " Int. hall 2 men by door\n278 Pink " Ext. cottage L.S. Buck\n279 " Ext. " Russell on car\n280 " Ext. " Buck on\n281 " Ext. " Russell on car comes f.g.\n282 " Ext. " Buck on - Russell on car enters\n283 B.W. " Int. room Mary by door - exits\n284 Pink " Ext. cottage Buck and Russell on - Russell goes up side of house\n285 B.W. " Int. hall 2 men by door\n286 Pink " Ext. cottage Russell climbing to window - Buck watching\n287 B.W. " Int. hall 2 men by door\n288 " Int. room Russell enters - Mary follows\n289 " Int. hall 2 men on\n290 " Int. room Russell and Mary on\nS. T. 91 " Stop! Stop!\n291 " Int. hall 2 men on\n292 " Int. room Russell and Mary on - 2 men enter - fight\n293 " Int. hall man falls
s1229l17205	14	MADE FROM LOCHIACRE\nREEL # 5\n\n534 B.W. Int. room on Molly and Mary\n535 S. T.147 " Sir Anthony Conway\n536 " Int. room on Molly\n537 " Int. " on Mary\n538 S. T.148 " Sir Anthony Conway\n539 " Int. room Mary and Molly on\n540 S. T.149 " We have come\n541 " Int. room on Molly\n542 " Int. " on Mary\n543 " Int. " on Molly takes off wig\n544 " Int. " on Mary\n545 " Int. " Mary and Molly on\n546 " Int. palace Russell talking to man\n547 Yellow Ext. road soldiers in auto\n548 B.W. Int. room Molly and Mary on\n549 S. T.151 " You are to\n550 " Int. room on Molly\n551 " Int. " on Mary\n552 " Int. " on Molly\n553 S. T.152 " I cannot! It would\n554 " Int. room on Mary\n555 " No scene\n556 " Int. room on Molly\n557 S. T.153 " Don't be foolish\n558 " Int. room Molly and Mary on\n559 S. T.154 " Anyway, Peiro is\n560 " Int. room on Molly\n561 " Int. " on Mary\n562 " Int. " on Molly\n563 " Int. " on Mary\n564 " Int. " on Molly\n565 S. T.155 " I do not know\n566 " Int. room on Mary\n567 " Int. " on Molly\n568 S. T.156 " Look in the\n569 " Int. room Molly and Mary look in mirror\n570 " Int. " Molly and Mary in mirror\n571 Yellow Ext. road auto on - exits\n572 B.W. Int. palace Russell talking to man\n573 Yellow Ext. " soldiers on - auto enters\n574 " Ext. " on Robt and Peiro in auto\n575 " Ext. " Ford and soldiers on\n576 " Ext. " Tiger and Charles on\n577 " Ext. " Ford on\n578 " Ext. " Ford looks at Tiger and Charles\n579 " Ext. " on Ford\n580 S. T.158 " Who are you\n581 " Ext. palace on Ford\n582 " Ext. " on Charles and Tiger
s1229l15171	8	LOVE'S HARVEST\nREEL TWO\n\nS.T. 41\n147 Dawn & the Fear\n148 Int. room-Mason enters writes\n149 Int. room-cu Mason at table\n150 Int. room-cu dog\nInt. room-cu Mason writing\nInsert 42\nGoodby me &\n151 Int. room-cu Mason writing\n152 Int. room-Mason at table gets up exits\n153 Int. room-cu Mason to door with dog exits\n154 Ext. porch-Mason out with dog exits\n155 Int. room-cu woman in bed\n156 Ext. woods-Mason enters with dog\n157 Int. room-cu woman in bed\n158 Int. woods-Mason & dog goes back-fade\nS.T. 43\nLater that day\n159 Fade in-Int. room-Dan-girl & lady read\nS.T. 44\nDo you suppose\n160 Int. room-Dan-girl & lady read\nS.T. 45\nI don't know\nS.T. 46\nOluja Board\n161 Int. room-Dan-girl & Lady read\n162 Int. room-cu Jim back turned\n163 Int. room-Jim comes to ladies\n164 Int. room-cu girl\n165 Int. room cu Jim\n166 Int. room-cu girl talks\nS.T. 47\nToo bad\n167 Int. room-Jim & ladies talk\n168 Int. room-cu Jim\nS.T. 48\nI wouldn't say\n169 Int. room-cu Jim fade\nS.T. 49\nAllen Hamilton\nS.T. 50\nBachelor\n170 Fade in-Int. cu Edwin\n171 Int. room-Edwin & girl talk\n172 Int. room-cu girl\n173 Int. office-Edwin & girl talk\nS.T. 51\nWith the courage\n174 Int. room-Mason with dog & people\n175 Int. room-cu Mason & dog\n176 Int. room-cu man\n177 Int. cu Mason\n178 Int. room-Mason-dog & people\n179 Int. room-cu Mason\n180 Int. office-Edwin & girl talk\nS.T. 52\nBe take two\n181 Int. office-Edwin & girl talk-she exits\n182 Int. room-cu Mason\nS.T. 53\nIts a shame\n183 Int. room-cu Mason\n184 Int. cu girl at door talks\nS.T. 55\nProfiteer\n185 Int. cu girl at door\n186 Int room-Mason dog & people
s1229l15171	5	LOVE'S HARVEST\nREEL ONE\n\n32\n33\nS.T. 22\n34\nExt. house Mason & dog on\n35\nExt. house Lady on\n36\nExt. house Mason & dog on\n37\nExt. house Lady on she exit\n38\nExt. house Lady enters-Mason & dog on-she exits\n39\nExt. house Mason enters & exits\n40\nInt. room-Father on Mason & dog enters\n41\nInt. room-Father & Mason on\n42\nS.T. 23\nI'll burn his cheek\n43\nInt. room-Father & Mason on\n44\nInt. room on dog\n45\nInt. room Father & Mason on he exits\n46\nInt. room on Mason exits\n47\nInt. room Mason on Father enters\n48\nS.T. 24\nHey what do you\n49\nInt. room on Father\n50\nInt. room on Mason\n51\nS.T. 25\nYou-you ought to be\n52\nInt. room-Mason & Father on\n53\nInt. room-on dog\n54\nInt. room Mason & Father on\n55\nInt. room Father enters\n56\nInt. room on Mason\n57\nInt. room dog on exit\n58\nInt. room-Father foot dog enter\n59\nInt. room on Mason\n60\nInt. room-Father on\n61\nInt. room-Father Mason & Dog on\n62\nInt. room-Mason enters & exits\n63\nExt. house Mason enters with dog & exits\n64\nInt. room-Father enters & exits\n65\nExt. shore-Mason & dog enter\n66\nExt. house-Father on he exits\n67\nExt. shore Mason on she exits\n68\nExt. shore Mason on with dog-father enters\n69\nExt. shore father on\n70\nExt. shore on Mason & dog\n71\nExt. shore Mason & dog on fade\n72\nS.T. 27\nAfraid to go home\n73\nExt. shore fade Mason & dog on fade\n74\nS.T. 28\nStep-dad disgusted with\nInsert 29\n75\nFor ten I have been\n76\nExt. shore fade Mason & dog on\n77\nExt. shore Mason & dog on-lady enters\n78\nS.T. 30\nPlease dearie\n79\nExt. shore on Mason & lady on\n80\nExt. shore dog & feet of Mason & Lady
s1229l15171	9	LOVE'S HARVEST\nREEL TWO\n\n187 Int. cu girl at door exits\n188 Int. room-Mason & dog-girl to door\n189 Int. office-cu Edwin\n190 Int. room-Mason & people dog to door\n191 Int. cu dog to door\n192 Int. office cu dog at door\n193 69 Int. room-Mason goes to door\n194 Int. cu legs to door\n195 Int. cu Mason & dog at door\n196 Int. cu Edwin at desk\n197 Int. cu Mason at door\n198 Int. cu dog at door\nS.T. 55 There angels\n199 Int. office cu Mason & dog\n200 Int. office Edwin on-Mason to him\nS.T. 56-57 ?! cu-Mason & Edwin\n201 Int. room cu Edwin & Mason\n202 70 Int. cu Mason & dog\nS.T. 58 I'm Jeanette\n203 71 Int. cu Edwin\nS.T. 59 A highly original\n204 72 Int. cu Mason & dog\nS.T. 60 B-nothing else\n205 73-75-76 Int. office-Mason & dog & Edwin\n206 Int. cu Edwin\nS.T. 61 The only place\nS.T. 62 Out. cu Mason & Edwin\n207 Int. office Edwin & Mason-she exits\n208 Int. cu Mason & dog to door exits\n209 Int. cu-Edwin fade\nS.T. 63 Homeless fade\n210 Fade in-ext. park-Mason & dog to bench\n211 Ext. cu Mason & dog on bench\n212 Ext. park cu-2 boys-exit\n213 Ext. Mason & dog on-3 boys enter\n214 Ext. cu boys\nS.T. 64 Hey kid\n215 Ext. cu dog on bench\n216 Ext. cu Mason puts Mason on bed\nS.T. 65 He -cu dog with bag\nS.T. 66-67 Aint a dog-exits\nS.T. 68 Mutt cu dog-exits\n217 Ext. cu Mason talks\n218 Ext. cu Mason & boys fight\n219 Ext. cu boy & dog-fight\n220 Ext. cu Mason exit\n221 Ext. cu boy to door\n222 Ext. cu Mason fights\n223 Ext. cu Mason fight\n224 Ext. dog after boy\n225 Ext. cu Mason fighting\n226 Ext. cu Mason's leg\n227 Ext. cu Mason fights\n228 Ext. Mason & boys fight
s1229l15171	19	LOVE'S MOVEMENT\nSCENE XIV.\n\n500\nInt. room Jim enters Leslie enters, Jim shows ring to her\n501\nInt. room close up hand holding case with ring\n502\nInt. Reception room Edwin and girl talking\n503\nFor Jane\n504\nInt. Reception room Edwin -girl talking\n505\nS.T. 1.9\nWhere is she\n506\nInt. Reception room Edwin girl talking he exits\n507\nInt. reception room near door Edwin enters goes to door\n508\nInt. reception room near curtain door Edwin opens door Mason Jim seen in b.g.\n509\nExt. balcony Mason Jim embracing\n510\nInt. doorway Edwin on girl in b.g. close up\n511\nInt. reception room near door Edwin on girl enters goes to Edwin close up\n512\nExt. balcony Mason, Jim embracing\n513\nInt. Reception room close view girl, Edwin he exits\n514\nInt. reception room Edwin enters sits down\n515\nInt. Reception room close view girl she exit\n516\nInt. Reception room Edwin seated girl enters goes to Edwin\n517\nInt. Reception room Edwin girl close up\n518\nS.T. 150\nIts true\n519\nInt. Reception room close up girl and Edwin\n520\nExt. balcony close view Jim and Mason\n521\nS.T. 151\nJane, Think Put happiness\n522\nExt. balcony close up Jane-Mason\n523\nS.T. 152\nIs it your gratitude to Hamilton\n524\nExt. balcony Jim-Mason close up\n525\nS.T. 153\nYou don't unite stand\n526\nExt. balcony close up Jim and Mason\n527\nInt. reception room close up Edwin -girl seated\n528\nInt. reception room Edwin rises and exits girl on\n529\nExt. balcony Jim and Mason talking Edwin enters\n530\nExt. balcony close up Ed in talking\n531\nS.T. 154\nJane\n532\nExt. balcony Jim-Mason-Edwin on talking\n533\nS.T. 155\nMr. Hamilton, Jane was willed\n534\nExt. balcony Jim-Mason Edwin talking\n535\nS.T. 156\nYou promised to do anything\n536\nExt. balcony close up Mason talking\n537\nExt. balcony Jim Mason Edwin talking\n538\nS.T. 157\nI shall expect you to\n539\nS.T. 158\nThe Man You Love\n540\nExt. balcony close up Mason\n541\nExt. balcony Jim-Mason-Edwin talking\n542\nExt. balcony close up Edwin-Mason-Mason kissed Edwin\n543\nExt. balcony Jim-Mason-Edwin-Edwin starts to exit\n544\nExt. balcony Edwin enters goes to door turns talks\n545\nS.T. 159\nNow you two make your plans\n546\nExt. balcony close up near door - Edwin on he turns starts to exit\n547\nExt. balcony close up Jim-Mason talks turned\n548\nInt. Reception room girl on Edwin enters\n549\nInt. Reception room Edwin girl close up\n550\nExt. balcony Jim Mason turn smiling\n551\nInt. Reception -Edwin girl close up\n552\nS.T. 160\nSpringtime and Autumn\n553\nInt. Reception close up Edwin -girl\n554\nExt. lawn two dogs\n555\nExt. lawn Close up of dogs\n556\nExt. balcony Jim-Mason talking\n557\nS.T. 161\nRose girl you wonderful\n558\nExt. Balcony Jim Mason embrace ---- Fade out.\nTHE END.
s1229l15171	16	LOVER'S HARVEST\nREEL FOUR\n\n474\n475\n476\nS.T. 109\n477\nS.T. 110\n478\nS.T. 111\n479\nS.T. 112\n480\n481\n482\n483\n484\nS.T. 114\n485\nS.T. 115\nS.T. 116\n486\nS.T. 117\n487\n488\n489\n490\n491\n492\nS.T. 118\n493\n494\n495\n496\n497\n498\n499\n500\n501\nS.T. 119\n502\n503\nS.T. 120\n504\n505\nS.T. 121\n506\nS.T. 122\n507\n508\nS.T. 123\nS.T. 124\n509\nS.T. 125\n510\nS.T. 126\n\nInt. Edwin & dog\nInt. Edwin gets up\nInt. cu Edwin\nI am going to Paris\nInt. cu Buttler\nAre you going\nInt. cu Edwin\nSo, I am going\nMrs. Jesmet Hamilton\nInt. Edwin & Buttler on fade out\nThe bashful\nInt. Fade in. Mason & Roy\nInt. cu Lillieusing Ponder\nInt. Mason & Roy at table\nInt. cu Mason\nInt. cu Roy\nDo you suppose\nInt. cu Mason\nI would\nAsk her\nInt. Mrs. soon & Roy at table\nI never thought\nInt. Mason & Roy on\nInt. Maid exits Jim on\nInt. Mason & Roy on Maid enters\nInt. Jim exits\nInt. Mason, Roy & Maid on Jim enters\nInt. Lillie exits\nInt. Mason Jim & Roy on Lillie enters\nThis is R. Atherton\nInt. cu Mason, Jim & Lillie\nInt. Roy & Lillie exits Mason-Jim on\nInt. cu Jim & Mason exits\nInt. cu Jim & Mason enter\nInt. Maid enters with flowers\nInt. Mason & Jim maid exits\nInt. cu Mason by flowers-Jim enters\nInt. cu Mason & Jim\nI brought\nInt. room-Mason & Jim sit down\nInt. cu Jim & Mason talking\nShe was willed\nInt. cu Mason & Jim\nInt. cu Mason\nAnd the Little\nInt. cu Jim & Mason\nI don't know\nInt. cu Jim & Mason\nInt. cu Mason\nAnd What became\nHeartless one\nInt. cu Jim & Mason\nShe was my\nInt. cu Mason & Jim\nAnd though I have\n\n511
s1229l15171	2	LOVE'S HARVEST.\nMAY 28 1920\n\nPhotoplay In Five Parts.\n\nStory by\nPearl Doles Bell\n\nDirected by\nHoward M. Mitchell\n\nfor\n\nTHE FOX FILM CORPORATION\n\nWILLIAM FOX.\nPresident.\n\nCopyright\n1920.\n\nWilliam Fox.
s1229l15171	15	LOVING HARVEST\nREAL POUR\n\n424\nInaert\n425\n426\n427\n428\n429\n430\n431\n432\n433\n434\n435\n436\n437\n438\n439\n440\n441\n442\n443\n444\n445\n446\n447\n448\n449\n450\n451\n452\n453\nS.T. 105\n454\nS.T. 106\n455\n456\n457\nS.T. 107\n458\n459\n460\n461\n462\n463\n464\n465\n466\n467\nS.T. 108\n468\n469\nInsert 108A\n470\n471\n472\n473\n\nExt. cu Jim writing note\nNote please pardon\nExt. cu Jim reads note\nInt. Mason exits man on\nExt. cu Mason enters\nExt. cu Jim on\nExt. cu Mason on\nExt. cu Jim\nExt. cu Mason turns\nExt. Jim on\nExt. 2 kids on\nExt. Jim on\nExt. street-boy on bicycle\nExt. Jim & boy\nExt. cu Mason exits\nExt. Jim & boy\nExt. street boy falls\nExt. Mason exits\nExt. Mason enters picks up boy-Jim grabs horse\nExt. cu Mason holding boy Jim-on boy exits\nExt. cu Mason & Jim\nExt. cu street auto enters\nExt. cu auto enters\nExt. cu Jim & Mason\nExt. cu carriage\nExt. cu Jim & Mason\nExt. cu man in auto\nExt. cu Jim & Mason he exits\nExt. Jim picks up Mason\nExt. Jim carries Mason to side walk\nExt. cu Jim & Mason\nardon me for\nExt. cu Mason & Jim\nI'm sorry, but\nExt. cu Jim & Mason talk she exits\nExt. Mason enters & exits\nExt. cu Jim fade out\nIn America Hamilton\nInt. fade in Edwin on\nInt. cu Edwin & dog\nInt. cu picture of Mason\nInt. Edwin & dog on\nInt. cu picture of Mason\nInt. Edwin & dog\nInt. cu dog\nInt. Edwin & dog\nInt. cu picture of Mason\nInt. cu Edwin dog jumps up\nIt's all right to have\nInt. Edwin & dog Buttler enters\nInt. cu Edwin takes letter from buttler\nLetter although Paris\nInt. cu Edwin reads letter looks at picture\nInt. cu Mason's picture\nInt. Edwin & dog\nInt. cu dog & picture
s1229l15171	11	LOVE'S HARVEST\nREEL THREE\n\nS.T. 79\n272 Allen Hamilton\n273 Int. room-cu Lillie sewing\n274 Int. room-Lillie on Edwin enters to her\n275 Int. room-cu Edwin enters to Lillie they talk exit\n276 Int. bedroom-cu Edwin & Lillie enter\n277 Int. bedroom-cu Mason & dog in bed\n278 Int. bedroom-cu Edwin & Lillie at door exit\n279 Int. bedroom-cu Edwin & Lillie on he points\n280 Int. bedroom-cu Joe & dogs tail\n281 Int. bedroom-cu Edwin & Lillie watch\n282 Int. bedroom-cu Mason wakes up-looks around\n283 Int. bedroom-cu Edwin & Lillie look\n284 Int. bedroom-cu Mason in bed with dog sits up\n285 Int. bedroom-Edwin & Lillie talk to Mason\n286 Int. bedroom-cu Lillie sits down by Mason\n287 Int. bedroom-cu Mason\n288 Int. bedroom-cu Mason & Lillie talks\n289 Int. bedroom-cu Edwin watches\n290 Int. bedroom-cu Mason & Lillie talking\n291 Int. bedroom-Mason in bed, Edwin & Lillie exits\n292 Int. bedroom-cu Mason & dog in bed\nS.T. 80\n293 See Buddy\n294 Int. bedroom-cu Mason & dog in bed-fade\nS.T. 81\n295 So they kept\n296 Int. bedroom-Mason on playing with dog\n297 Int. bedroom-cu Shirley\n298 Int. bedroom-cu dog\n299 Int. bedroom-cu Mason\n300 Int. bedroom-Mason & dog Lillie enters\n301 Int. bedroom cu Lillie enters to Mason with dress\n302 Int. bedroom-cu Mason kisses Lillie\n303 Int. bedroom-Mason & Lillie on Mason gets in bed\n304 Int. bedroom-Lillie comes to Pg. exits\n305 Int. bedroom-Mason in bed-dog watches\n306 Int. bedroom-cu dog\n307 Int. bedroom-cu Mason talking\n308 S.T. 82\n309 Don't bark buddy\n310 Int. bedroom-cu Mason\n311 Int. bedroom-cu Mason gets out of bed\n312 Int. bedroom-cu Mason crawls up to dog\nS.T. 83\n313 Your tried\n314 Int. bedroom-cu Mason talking to dog\n315 Int. parlor-cu Edwin & Lillie on talking\n316 Int. bedroom-cu Mason & dog\n317 Int. parlor-cu Edwin & Lillie on talking\n318 Int. bedroom-cu Mason & dog she singing-dissolve to\n319 music-dissolve to Edwin & Lillie\n320 Int. parlor-cu Edwin talks\nS.T. 84\n321 A child with a\n322 Int. parlor-cu Edwin & Lillie\n323 Int. bedroom-cu Mason & dog she exits fade\n324 Int. cu Mason enters kneels & prays
s1229l15171	17	LOVE'S HARVEST\nREEL FOUR\n\n511\nS.T. 127\nInt. cu Mason\nOh if there\n\n512\nS.T. 128\nInt. cu Mason & Jim talking\nLife will never\n\n513\nInt. cu Mason & Jim\n\n514\nS.T. 129\nInt. cu Mason puts head down-on Jim-fade out\nTrail O'Dreams\n\n515\nExt. fade in Mason & Jim-enter & exit\n\n516\nExt. cu Mason & Jim enter sits down bench\n\n517\nExt. cu Mason & Jim sitting\n\nS.T. 130 Meantime Hamilton\n\n518\nInt. Edwin & Lilie enter\n\nS.T. 131\nAre you sure\n\n519\nInt. Edwin & Lilie exit\n\n520\nExt. cu Mason & Jim sitting on bench\n\n521\nExt. cu Mason\nI make me\n\nS.T. 132\n\n522\nExt. cu Mason & Jim\n\n523\nExt. cu Birds on tree\n\n524\nExt. cu Mason & Jim\n\n525\nExt. cu Birds on tree\n\n526\nExt. cu Mason & Jim\n\nS.T. 133\nThey are happy\n\n527\nExt. cu Mason & Jim\n\n528\nExt. cu Mason & Jim\n\nS.T. 134\nMay I bring\n\n529\nExt. cu Mason & Jim kiss\n\n530\nExt. Mason & Jim kiss they exit\nEnd of Reel Four
s1229l15171	7	LOVE'S HARVEST\nREEL ONE\n\n124\nExt. house Mason & dog enter\n125\nExt. house cu Mason\n126\nExt. house cu dog at Mason feet\n127\nExt. house cu Mason\n128\nExt. house cu flower on Miss Wilson\n129\nExt. house cu Mason\n130\nExt. house-Bush on\n131\nExt. house cu Mason\n132\nExt. house Mason & dog exit\n133\nExt. house Miss Wilson on Mason enters\n134\nExt. house-Jim, man & girls on\n135\nExt. house Miss Wilson & Mason & dog on\n136\nExt. house Jim on he exits\n137\nExt. house Miss Wilson, Mason & dog on Jim enters\nMiss Wilson exits\n138\nExt. home Mason Jim & dog on\n139\nExt. house cu Mason\nS.T. 37\nOh my poor roses\n140\nExt. house Mason, Jim & dog on\n141\nExt. house cu Jim\nS.T. 38\nI'm sorry I'll come\n142\nExt. home Mason, Jim & dog on\n143\nExt. house Mason, Jim & dog on Jim exit\n144\nExt. house cu Mason\n145\nExt. house-cu dog by Mason\n146\nExt. house cu Mason-fade\nEnd of Reel One\n\n147\nInt. room-cu Jim\n148\nI couldn't say\n149\nInt. room-cu Jim fade\n150\nAllen Hamilton\n151\nBachelor\n152\nFade in-Zolt. cu Edvin\n153\nInt. room-Edwin & girl, talk\n154\nInt. room-cu girl\n155\nInt. office-Edwin & girl talk\n156\nwith the courage\n157\nInt. room-Mason with dog & people\n158\nInt. room-cu Mason & dog\n159\nInt. room-cu man\n160\nInt. cu Mason\n161\nInt. room-Mason-dog & people\n162\nInt. room-cu Mason\n163\nInt. office-Edwin & girl talk\n164\nS.T. 52\nNo take the\n165\nInt. office-Edwin & girl talk-she exits\n166\nInt. room-cu Mason\n167\nIt's a shame\n168\nInt. room-cu Mason\n169\nInt. cu girl at door-dates\n170\nInt. cu girl at door\n171\nInt. room-Mason dog & people\n172\nInt. room-Mason dog & people\n173\nInt. room-Mason dog & people\n174\nInt. room-Mason dog & people\n175\nInt. room-Mason dog & people\n176\nInt. room-Mason dog & people\n177\nInt. room-Mason dog & people\n178\nInt. room-Mason dog & people\n179\nInt. room-Mason dog & people\n180\nInt. room-Mason dog & people\n181\nInt. room-Mason dog & people\n182\nInt. room-Mason dog & people\n183\nInt. room-Mason dog & people\n184\nInt. room-Mason dog & people\n185\nInt. room-Mason dog & people\n186\nInt. room-Mason dog & people\n187\nInt. room-Mason dog & people\n188\nInt. room-Mason dog & people\n189\nInt. room-Mason dog & people\n190\nInt. room-Mason dog & people\n191\nInt. room-Mason dog & people\n192\nInt. room-Mason dog & people\n193\nInt. room-Mason dog & people\n194\nInt. room-Mason dog & people\n195\nInt. room-Mason dog & people\n196\nInt. room-Mason dog & people\n197\nInt. room-Mason dog & people\n198\nInt. room-Mason dog & people\n199\nInt. room-Mason dog & people\n200\nInt. room-Mason dog & people\n201\nInt. room-Mason dog & people\n202\nInt. room-Mason dog & people\n203\nInt. room-Mason dog & people\n204\nInt. room-Mason dog & people\n205\nInt. room-Mason dog & people\n206\nInt. room-Mason dog & people\n207\nInt. room-Mason dog & people\n208\nInt. room-Mason dog & people\n209\nInt. room-Mason dog & people\n210\nInt. room-Mason dog & people\n211\nInt. room-Mason dog & people\n212\nInt. room-Mason dog & people\n213\nInt. room-Mason dog & people\n214\nInt. room-Mason dog & people\n215\nInt. room-Mason dog & people\n216\nInt. room-Mason dog & people\n217\nInt. room-Mason dog & people\n218\nInt. room-Mason dog & people\n219\nInt. room-Mason dog & people\n220\nInt. room-Mason dog & people\n221\nInt. room-Mason dog & people\n222\nInt. room-Mason dog & people\n223\nInt. room-Mason dog & people\n224\nInt. room-Mason dog & people\n225\nInt. room-Mason dog & people\n226\nInt. room-Mason dog & people\n227\nInt. room-Mason dog & people\n228\nInt. room-Mason dog & people\n229\nInt. room-Mason dog & people\n230\nInt. room-Mason dog & people\n231\nInt. room-Mason dog & people\n232\nInt. room-Mason dog & people\n233\nInt. room-Mason dog & people\n234\nInt. room-Mason dog & people\n235\nInt. room-Mason dog & people\n236\nInt. room-Mason dog & people\n237\nInt. room-Mason dog & people\n238\nInt. room-Mason dog & people\n239\nInt. room-Mason dog & people\n240\nInt. room-Mason dog & people\n241\nInt. room-Mason dog & people\n242\nInt. room-Mason dog & people\n243\nInt. room-Mason dog & people\n244\nInt. room-Mason dog & people\n245\nInt. room-Mason dog & people\n246\nInt. room-Mason dog & people\n247\nInt. room-Mason dog & people\n248\nInt. room-Mason dog & people\n249\nInt. room-Mason dog & people\n250\nInt. room-Mason dog & people\n251\nInt. room-Mason dog & people\n252\nInt. room-Mason dog & people\n253\nInt. room-Mason dog & people\n254\nInt. room-Mason dog & people\n255\nInt. room-Mason dog & people\n256\nInt. room-Mason dog & people\n257\nInt. room-Mason dog & people\n258\nInt. room-Mason dog & people\n259\nInt. room-Mason dog & people\n260\nInt. room-Mason dog & people\n261\nInt. room-Mason dog & people\n262\nInt. room-Mason dog & people\n263\nInt. room-Mason dog & people\n264\nInt. room-Mason dog & people\n265\nInt. room-Mason dog & people\n266\nInt. room-Mason dog & people\n267\nInt. room-Mason dog & people\n268\nInt. room-Mason dog & people\n269\nInt. room-Mason dog & people\n270\nInt. room-Mason dog & people\n271\nInt. room-Mason dog & people\n272\nInt. room-Mason dog & people\n273\nInt. room-Mason dog & people\n274\nInt. room-Mason dog & people\n275\nInt. room-Mason dog & people\n276\nInt. room-Mason dog & people\n277\nInt. room-Mason dog & people\n278\nInt. room-Mason dog & people\n279\nInt. room-Mason dog & people\n280\nInt. room-Mason dog & people\n281\nInt. room-Mason dog & people\n282\nInt. room-Mason dog & people\n283\nInt. room-Mason dog & people\n284\nInt. room-Mason dog & people\n285\nInt. room-Mason dog & people\n286\nInt. room-Mason dog & people\n287\nInt. room-Mason dog & people\n288\nInt. room-Mason dog & people\n289\nInt. room-Mason dog & people\n290\nInt. room-Mason dog & people\n291\nInt. room-Mason dog & people\n292\nInt. room-Mason dog & people\n293\nInt. room-Mason dog & people\n294\nInt. room-Mason dog & people\n295\nInt. room-Mason dog & people\n296\nInt. room-Mason dog & people\n297\nInt. room-Mason dog & people\n298\nInt. room-Mason dog & people\n299\nInt. room-Mason dog & people\n300\nInt. room-Mason dog & people\n301\nInt. room-Mason dog & people\n302\nInt. room-Mason dog & people\n303\nInt. room-Mason dog & people\n304\nInt. room-Mason dog & people\n305\nInt. room-Mason dog & people\n306\nInt. room-Mason dog & people\n307\nInt. room-Mason dog & people\n308\nInt. room-Mason dog & people\n309\nInt. room-Mason dog & people\n310\nInt. room-Mason dog & people\n311\nInt. room-Mason dog & people\n312\nInt. room-Mason dog & people\n313\nInt. room-Mason dog & people\n314\nInt. room-Mason dog & people\n315\nInt. room-Mason dog & people\n316\nInt. room-Mason dog & people\n317\nInt. room-Mason dog & people\n318\nInt. room-Mason dog & people\n319\nInt. room-Mason dog & people\n320\nInt. room-Mason dog & people\n321\nInt. room-Mason dog & people\n322\nInt. room-Mason dog & people\n323\nInt. room-Mason dog & people\n324\nInt. room-Mason dog & people\n325\nInt. room-Mason dog & people\n326\nInt. room-Mason dog & people\n327\nInt. room-Mason dog & people\n328\nInt. room-Mason dog & people\n329\nInt. room-Mason dog & people\n330\nInt. room-Mason dog & people\n331\nInt. room-Mason dog & people\n332\nInt. room-Mason dog & people\n333\nInt. room-Mason dog & people\n334\nInt. room-Mason dog & people\n335\nInt. room-Mason dog & people\n336\nInt. room-Mason dog & people\n337\nInt. room-Mason dog & people\n338\nInt. room-Mason dog & people\n339\nInt. room-Mason dog & people\n340\nInt. room-Mason dog & people\n341\nInt. room-Mason dog & people\n342\nInt. room-Mason dog & people\n343\nInt. room-Mason dog & people\n344\nInt. room-Mason dog & people\n345\nInt. room-Mason dog & people\n346\nInt. room-Mason dog & people\n347\nInt. room-Mason dog & people\n348\nInt. room-Mason dog & people\n349\nInt. room-Mason dog & people\n350\nInt. room-Mason dog & people\n351\nInt. room-Mason dog & people\n352\nInt. room-Mason dog & people\n353\nInt. room-Mason dog & people\n354\nInt. room-Mason dog & people\n355\nInt. room-Mason dog & people\n356\nInt. room-Mason dog & people\n357\nInt. room-Mason dog & people\n358\nInt. room-Mason dog & people\n359\nInt. room-Mason dog & people\n360\nInt. room-Mason dog & people\n361\nInt. room-Mason dog & people\n362\nInt. room-Mason dog & people\n363\nInt. room-Mason dog & people\n364\nInt. room-Mason dog & people\n365\nInt. room-Mason dog & people\n366\nInt. room-Mason dog & people\n367\nInt. room-Mason dog & people\n368\nInt. room-Mason dog & people\n369\nInt. room-Mason dog & people\n370\nInt. room-Mason dog & people\n371\nInt. room-Mason dog & people\n372\nInt. room-Mason dog & people\n373\nInt. room-Mason dog & people\n374\nInt. room-Mason dog & people\n375\nInt. room-Mason dog & people\n376\nInt. room-Mason dog & people\n377\nInt. room-Mason dog & people\n378\nInt. room-Mason dog & people\n379\nInt. room-Mason dog & people\n380\nInt. room-Mason dog & people\n381\nInt. room-Mason dog & people\n382\nInt. room-Mason dog & people\n383\nInt. room-Mason dog & people\n384\nInt. room-Mason dog & people\n385\nInt. room-Mason dog & people\n386\nInt. room-Mason dog & people\n387\nInt. room-Mason dog & people\n388\nInt. room-Mason dog & people\n389\nInt. room-Mason dog & people\n390\nInt. room-Mason dog & people\n391\nInt. room-Mason dog & people\n392\nInt. room-Mason dog & people\n393\nInt. room-Mason dog & people\n394\nInt. room-Mason dog & people\n395\nInt. room-Mason dog & people\n396\nInt. room-Mason dog & people\n397\nInt. room-Mason dog & people\n398\nInt. room-Mason dog & people\n399\nInt. room-Mason dog & people\n400\nInt. room-Mason dog & people\n401\nInt. room-Mason dog & people\n402\nInt. room-Mason dog & people\n403\nInt. room-Mason dog & people\n404\nInt. room-Mason dog & people\n405\nInt. room-Mason dog & people\n406\nInt. room-Mason dog & people\n407\nInt. room-Mason dog & people\n408\nInt. room-Mason dog & people\n409\nInt. room-Mason dog & people\n410\nInt. room-Mason dog & people\n411\nInt. room-Mason dog & people\n412\nInt. room-Mason dog & people\n413\nInt. room-Mason dog & people\n414\nInt. room-Mason dog & people\n415\nInt. room-Mason dog & people\n416\nInt. room-Mason dog & people\n417\nInt. room-Mason dog & people\n418\nInt. room-Mason dog & people\n419\nInt. room-Mason dog & people\n420\nInt. room-Mason dog & people\n421\nInt. room-Mason dog & people\n422\nInt. room-Mason dog & people\n423\nInt. room-Mason dog & people\n424\nInt. room-Mason dog & people\n425\nInt. room-Mason dog & people\n426\nInt. room-Mason dog & people\n427\nInt. room-Mason dog & people\n428\nInt. room-Mason dog & people\n429\nInt. room-Mason dog & people\n430\nInt. room-Mason dog & people\n431\nInt. room-Mason dog & people\n432\nInt. room-Mason dog & people\n433\nInt. room-Mason dog & people\n434\nInt. room-Mason dog & people\n435\nInt. room-Mason dog & people\n436\nInt. room-Mason dog & people\n437\nInt. room-Mason dog & people\n438\nInt. room-Mason dog & people\n43
s1229l15171	1	人15/17/
s1229l15171	12	LOVE'S HARVEST\nREEL THREE\n\n319 Int. bedroom-cu dog-exits\n320 Int. bedroom-cu Mason praying dog enters kneels by her\n321 Int. bedroom-cu Mason & dog praying\n322 Int. bedroom-cu Mason & dog praying-fade\nS.T. 85\n323 Jim Atherton\n324 Int. court-Jim & detective on\n325 Int. court-cu Jim, woman with children enters\n326 Int. court-cu-a woman & 3 children\n327 Int. court-cu Jim-woman & 3 children\n328 Int. court-cu Detective\n329 Int. court-cu Jim, woman & 3 children\n330 Int. court-cu children\n331 Int. court-Jim & detective go to Bg. children\n332 Int. court-cu Jim & detective at desk\nS.T. 86\n333 I'm going abroad\n334 Int. court-cu Jim & detective at desk fade\nS.T. 87\n335 I'm going\n336 Int. room-fade-Edwin enters to Butler\n337 Int. room-Edwin hands butler coat & hat goes to Lillie Bg.\n338 Int. room-Edwin sits down talks to Lillie\n339 Int. room-Mason on singing man at piano\n340 Int. room-cu Mason singing\n341 Int. room-cu dog\n342 Int. room-cu Mason singing\n343 Int. room-cu man at piano\n344 Int. room-cu Mason coughs\n345 Int. room-cu Mason & man at piano\n346 Int. room-cu Edwin & Lillie talking\n347 Int. room-cu Mason & man at piano\n348 Int. room-cu Edwin & Lillie on talking exit\n349 Int. room-Edwin & Lillie enter to Mason, man exits\n350 Int. room-cu Mason hugs Edwin, he sits down talks\nS.T. 88\n351 I have a\n352 Int. room-cu Mason\n353 Int. room-cu Mason & Edwin talk\n354 Int. room-cu Mason & Edwin talk\n355 Int. room-cu Mason laughs\n356 Int. room-cu Mason kisses Billie\n357 Int. room-cu Mason on kisses Edwin\nS.T. 90\n358 Poor old Daddy\n359 Int. room-cu Mason & Edwin talk\n360 I'll leave Sudie\n361 Int. room-cu dog\n362 Int. room-cu Edwin & Lillie\n363 Int. room-cu Mason talks to dog-Edwin & Lillie watch\n364 Int. room-cu Mason talking to dog Edwin & Lillie watch\nS.T. 92\n365 Sudie says\n366 Int. room-Mason, Edwin, Lillie on talking fade\nS.T. 93\n367 Jim Atherton found
s1229l15171	14	LOVE'S HARVEST\nROLL THREE\n\n8.7. 98\n413\nWell Roy\nInt. room-Roy & Lilie on talking\n414\n8.7. 99\n415\nA blame sight\nInt. room-Roy & Lilie on talking\n416\nInt. room-Mason on singing man at piano\n417\nInt. room-cu Mason singing\n418\nInt. room-cu Man at piano\n419\nInt. room-cu Mason\n8.7. 100\n420\ngo home see\nInt. room-cu Mason talking\n8.7. 101\n421\nYes it is\nInt. room-Mason and man at piano\n422\nInt. room-cu Mason talking\n8.7. 102\n423\nBut maybe\nInt. room-Mason on man at piano gets up talks to her\nEnd of Reel Three\n\n447\n448\n449\n450\n451\n452\n453\n454\n455\n456\n457\n8.7. 107\n458\nInt. room in train in\n459\nInt. on train & dog\n460\nInt. on picture of Mason\n461\nInt. on train & dog on\n462\nInt. on picture of Mason\n463\nInt. Stein & dog\n464\nInt. on dog\n465\nInt. Stein & dog\n466\nInt. on picture of Mason\n467\nInt. on Stein dog jumps up\n8.7. 108\n468\nIt's all right to have\n469\nInt. Stein & dog Butler enters\n470\nInt. on Stein takes letter from butler\nInsert 108A\n471\nLetter although Paris\n472\nInt. on Stein reads letter looks at picture\n473\nInt. on Mason's picture\n474\nInt. on Stein & dog\n475\nInt. on Stein & picture
s1229l15171	18	JOE'S HAVEN\nPAGE 218.\n\n531\nInt. living room Edwin and girl on walk over to door\n532\nInt. room on Edwin and girl, girl talks\n533\nI will take a little walk\n534\nInt. room Edwin and girl kiss, girl exits\n535\nExt. steps Mason and Jim enters, stand on steps\n536\nExt. garden on Jim takes off hat, goes to kiss Mason exits\n537\nInt. room Edwin on Mason enters\n538\nInt. room on Mason laughs\n539\nInt. room Edwin stretches out arms, Mason runs up to him\n540\nInt. room on Edwin and Mason hugging close up\n541\nInt. room on Mason, feet kicking\n542\nInt. room on Edwin and Mason hugging he only sees her down\n543\nWell, how's the career?\n544\nInt. room on Edwin and Mason, she raises hand\n545\nIt is --it's almost\n546\nInt. room on Edwin and Mason Edwin speaks\n547\n"Jane! my little Jane!"\n548\nInt. room on Edwin and Mason\n549\nInt. hall dog jumping on door\n550\nInt. room on Edwin and Mason, Edwin talks\n551\nI--I've come all the way\n552\nInt. room on Mason she talks\n553\nI'll do anything\n554\nInt. room Edwin and Mason on, Edwin raises arm\n555\nInt. hall dog on jumps on door\n556\nInt. room Edwin on Mason runs to door lets dog in\n557\nInt. room dog jumps into Mason's arms she kneels down\n558\nInt. room Edwin standing by table, turns head\n559\nInt. room Mason on floor holding dog in arms\n560\nInt. room Edwin by table exits\n561\nInt. room Mason and dog on floor Edwin enters\n562\nInt. room on Mason on floor with dog looks up\n563\nInt. room on Edwin talks\n564\nThen let's put off\n565\nInt. room Mason and dog on floor Edwin in --fade out\n566\nGratitute "\n567\nExt. porch fade in Mason sitting down, dog on\n568\nExt. Verander --Leslie enters, exits\n569\nExt. Verander, on Mason Leslie enters, puts hand on Mason\n570\nI'm crying because\n571\nExt. Verander, on Mason and Leslie\n572\nMy brother\n573\nExt. Verander on Mason and Leslie\n574\nExt. road Jim enters, exit\n575\nExt. Verander, Mason and Leslie kiss -- Leslie exits\n576\nExt. road Jim enters stops and looks\n577\nExt. Verander on Mason takes hand from face\n578\nExt. garden on Jim laughs, exits\n579\nExt. Verander on -- Mason on Jim enters jumps over wall\n580\nExt. Verander on Jim and Mason, Jim puts hat and cane down\n581\nExt. Verander on Jim goes to put ring on Mason finger, she pulls back\n582\nExt. on Mason\n583\nExt. on Jim and Mason\n584\nMr. Hamilton just arrived\n585\nExt. Verander on Jim and Mason, Mason turns around\n586\nExt. Verander Mason enters\n587\nExt. Verander Jim on exits\n588\nExt. Mason on Jim enters, she turns they kiss\n589\nInt. room on Leslie\n590\nInt. room doors open Jim enters --exits
s1229l15171	6	LOVE'S HARVEST\nREEL ONE\n\n77\nS.T. 31\nExt. shore cu Mason & lady\nWe don't want to\n\n78\nExt. shore Mason & Lady on Mason runs to back\n\n79\nExt. shore Mason & Lady on long shot\n\n80\nExt. shore Mason enter\n\n81\nExt. shore Lady on she exits\n\n82\nExt. shore Mason & Lady on long shot\n\n83\nExt. shore Mason & Lady on\n\n84\nExt. Mason-enters runs in water\n\n85\nExt. shore Lady on\n\n86\nExt. shore cu Mason & dog fade\n\nS.T. 32\n87\nExt. house fade Mason & dog on\n\n88\nExt. road-auto on it exit\n\n89\nExt. house-Mason & dog on\n\n90\nExt. house-auto enters\n\n91\nExt. house Mason & dog on\n\n92\nExt. house cu Jim\n\n93\nExt. house Mason & dog on\n\n94\nExt. house Jim & Lillie & people on-dog enters\n\n95\nExt. house-Jim & people on\n\n96\nExt. house dog & Jim on\n\n97\nExt. house Mason on-she exits\n\n98\nExt. house-Mason enters\n\n99\nExt. house-dog & Jim on\n\n100\nExt. house-cu Mason\n\n101\nExt. house-cu Mason feet\n\n102\nExt. house cu Mason\n\n103\nExt. house cu Mason feet\n\n104\nExt. house cu Mason-she exits\n\n105\nExt. house-Jim & dog on Mason enters\n\n106\nExt. house cu Jim\n\nS.T. 33\n107\nI'm Jim Atherton I\n\n108\nExt. house Mason, Jim & dog on\n\n109\nExt. house cu Mason\n\nS.T. 34\n110\nI should say so\n\n111\nExt. house cu Mason\n\n112\nExt. house Mason & Jim\n\nS.T. 35\n113\nWell let's play\n\n114\nExt. house Mason & Jim on Wilson enters\n\nS.T. 36\n115\nMeet my Fiancee\n\n116\nExt. house Mason, Jim & Miss Wilson on\n\n117\nExt. house cu Mason\n\n118\nExt. house cu Miss Wilson\n\n119\nExt. house Mason, Jim & Miss Wilson on\n\n120\nExt. house cu Mason\n\n121\nExt. house hand enters picks flower\n\n122\nExt. house cu Miss Wilson\n\n123\nExt. house-dog on exit
s1229l15171	20	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l15171	10	LOVE'S HARVEST\nREEL TWO\n\n220\nExt. dog fighting with boy\n230\nExt. Mason & boys fight\n231\nExt. cu Mason falls\n232\nExt. cu Mason\n233\nExt. cu Mason gets up\n234\nExt. boy on-Mason falls on him\nS.T. 69\nFate and a\n235\nExt. cu Edwin in auto\n236\nExt. park-Mason & boys fight\n237\nExt. cu Edwin in auto\n238\nExt. Mason & boys fight-Edwin enters\n239\nExt. park-boys run back\n240\nExt. park-Mason-Edwin & boy-boy enter\n241\nExt. boy runs back\n242\nExt. Mason & Edwin go back to bench\n243\nExt. cu-Mason & Edwin\n244\nExt. cu Edwin\nS.T. 70\nWhat are you\n245\nExt. cu Mason\nS.T. 71\nWe haven't any\n246\nExt. cu Edwin\nS.T. 72\nHow would\n247\nExt. park-cu Edwin & Mason\nS.T. 73-74-75\nDinner-3 sizes\n248\nExt. cu Edwin & Mason talk\n249\nExt. cu dog\n250\nExt. cu Mason & Edwin\n251\nExt. park Mason & Edwin get up exit\n252\nExt.-Edwin & Mason-get in auto\n253\nExt. cu-Mason & Edwin get in auto-dissolve to clock\nback to auto-fade\n254\nFade in Int. room-Edwin enter with Mason\n255\nInt. Mason & Edwin upstairs\n256\nInt. cu Edwin with Mason exit\n257\nInt. cu dog with bag\n258\nInt. Edwin upstairs dog after\n259\nInt. hall-Edwin enter with Mason\n260\nInt. room-Edwin enters with Mason\n261\nInt. cu Edwin puts Mason on bed\n262\nInt.-cu dog with bag\n263\nInt. Edwin caresses-Mason\n264\nInt. cu dog-exits\n265\nInt. Edwin caresses-Mason-dog jumps\n266\nInt. cu Edwin\n267\nInt. cu Mason in bed\n268\nInt. cu Edwin exit\n269\nInt. cu Edwin to door\n270\nInt. Mason & dog in bed\n271\nInt. Edwin by door-exits\nEnd of Reel Two
s1229l15171	3	WILLIAM FOX PRESENTS SHIRLEY TEMPLE\nStory by Pearl Dolan Bell\nDirected by Howard M. Altonell\nPhotography by George Schmolderman\nCopyright: William Fox\n\nMy dear yoder in the\nThis financial apparent\nafter fighting unscorred\nSoon after ward a gentlem\n1\nInt. room Fido-Dan at desk 6 pm\n2\nInt. room Ted on Jim\n3\nInt. room Fido on Jim\n4\nInt. room on Jim\ncheck Jane Day $60.00\n5\nInt. room on Jim\nJane Day what\n6\nInt. room Dan & Jim at desk\n7\nYour uncle's brother\n8\nInt. room Dan & Jim at desk\nThat makes me\nLOVE HARVEST fade\n== == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==
s1229l15171	13	LOVE'S HARVEST\nREEL THREE\n\n365\n366\n367\n368\n369\n370\n371\n372\n373\nS.T. 94-\n374\n375\n376\n377\n378\n379\n380\n381\n382\n383\n384\n385\n386\n387\n388\n389\n390\n391\n392\n393\nS.T. 95\n394\nS.T. 96\n395\n396\n397\n398\n399\n400\n401\n402\n403\n404\n405\n406\n407\n408\nS.T. 97\n409\n410\n411\n412\n\nExt. street-fade-french street\nInt. room-ou Jim lights pipe\nInt. room-Jim on smoking talking\nExt. street-French street people on\nExt. Window-ou Jim enters talking\nExt. street-children on playing\nExt. window-ou Jim looking\nExt. street-People in\nExt. window-ou Jim looking\non her way\nExt. street-Mason enters watches kids dance\nExt. street-ou kids dancing\nExt. street-ou Mason watching\nExt. street-ou Men playing\nExt. street-ou Mason laughing turns\nExt. street-Mason on exits in Fg.\nExt. street-ou Children playing, Mason in Bg;\nExt. window-ou Jim watching\nExt. street-children on playing\nExt. street-ou Mason watching\nExt. window-ou Jim looking turns\nInt. room-Jim in Bg. exits\nExt. street-Mason on talking to kids\nExt. street-Jim enters at door\nExt. street-ou Mason on talking\nExt. street-Jim at door looking\nExt. street-ou Mason looking\nExt. street-Jim at door runs to Fg. exits\nExt. street-Mason on Jim enters to her\nExt. street-ou Jim talks\nThy Jane\nExt. street-ou Mason talks\nI thought American\nExt. street-Mason & Jim on she exits\nExt. street-Mason enters to door exits\nExt. street-Jim on exits\nInt. hall-Mason comes upstairs goes to door\nInt. room-ou Man & woman on Mason enter goes to Bg.\nInt. room-ou Mason enters to window\nExt. street-Jim on man on bicycle passes him\nInt. room-ou Mason at window\nInt. room-ou Man & woman on she exits-Mason in\nBg. by window\nInt. room-ou man by door turns\nInt. room-ou Mason by window turns\nInt. room-ou Man by door\nInt. room-ou Mason by window exits\nInt. room-ou Man by door Mason enters to him\nSay Herrick\nInt. room-Hoy & Lilie on talking\nInt. room-ou Talking\nInt. room-Hoy & Lilie on talking\nInt. room-ou Lilie talks
s1229l15171	4	LOVE'S HARVEST\nRAMEL 088\n\nS.T. 1\nWilliam Fox presents Shirley Mason\nS.T. 2\nStory by Pearl Doles Bell\nS.T. 3\nDirected by Howard M. Mitonell\nS.T. 4\nPhotography by George Schneiderman\nS.T. 5\nCopyright William Fox\nS.T. 6\nWhy back yoder in the\nS.T. 7\nThis financial uppercut\nS.T. 8\nAfter fighting unscarred\nS.T. 9\nSeen after ward a gentleman\n\n1\nInt. room Fade-Dan at desk & man\n2\nInt. room fade cu Jim\n3\nInt. room fade cu Dan\n4\nInt. room cu Jim\n5\ncheck Jane Day $50.00\n6\nInt. room cu Jim\n7\nJane Day what\n8\nInt. room Dan & Jim at desk\n9\nS.T. 10\nYour uncle's brother\n10\nInt. room-Dan & Jim at desk\n11\nThat makes me\n12\nInt. room-Dan & Jim at desk fade\n13\nOn the Clem Atherton-dissolve into mortgage\n14\nExt. house fade house in Bg. fade\n15\nExt. shore fade-Mason & dog in water\n16\nExt. shore Mason & dog on\n17\nAmong the uncultivated\n18\nExt. shore cu Mason\n19\nJane had two friends\n20\nExt. shore Mason & dog on\n21\nExt. shore Mason & dog in Bg. exit\n22\nExt. house Mason & dog enter\n23\nExt. house cu Mason & dog\n24\nExt. house cu dog\n25\nExt. house Mason & dog on\n26\nExt. house Mason & dog on\n27\nExt. house bug on ground\n28\nExt. house Mason & dog on\n29\nBefore we go\n30\nS.T. 17\nStep-father\n31\nS.T. 18\nThe joy of living\n32\nInt. room-cu father\n33\nInt. room-father & lady on\n34\nInt. room cu father\n35\nCheck Jane Day $50.00\n36\nInt. room father & Lady on\n37\nMakes a check out\n38\nInt. room father & lady on\n39\nExt. house Mason & dog on\n40\nExt. house cu dog\n41\nS.T. 21\nB.W.! BOW! DISSOLVE into Why don't
s1229l17205	9	THE LADY FROM LONGACRE\nREEL 4 3\n\n294 B.W. Int. room man by Mary - Russell knocks him out\n295 " Int. hall Russell fighting 2 men\n296 " Int. " woman on - man falls down stairs\n297 " Int. " Russell picks man up - hits him\n298 " Int. " woman hitting man\n299 Pink Ext. cottage Buck on - hits man\n300 B.W. Int. hall Buck after man - woman on\n301 " Int. " Russell and man fighting\n302 " Int. " Buck and man on fighting\n303 " Int. " Russell and man fighting\n304 " Int. " Russell after man on stairs\n305 " Int. " man comes on\n306 " Int. " 3 cu Russell and 2 men\n\n3. T. 92 " We want her\n307 " Int. hall 3 cu Russell and 2 men\n3. T. 93 " Do you not know\n308 " Int. hall 3 cu Russell and 2 men\n309 " Int. " on Mary and Russell\n3. T. 94 " Yes, it is true\n310 " Int. hall on Mary and Russell\n3. T. 95 " I came here to\n311 " Int. hall on Mary and Russell\n312 " Int. " 3 cu Russell and 2 men\n3. T. 96 " But how does that\n313 " Int. hall 3 cu Russell and 2 men\n3. T. 97 " We are agents of\n314 " Int. hall 3 cu Russell and 2 men\n3. T. 98 " ---- we heard that\n315 " Int. hall on Russell and 2 men\n3. T. 99 " Since we all seem\n316 " Int. hall on Russell and 2 men\n317 " Int. room 3 cu Mary, Russell and 2 men\n318 " Int. " on Mary and Russell\n3. T. 100 " Until you can\n319 " Int. room on Mary and Russell - she exits\n320 " Int. " 3 cu Russell and 2 men - Buck enters\n\n3. T. 101 " And Mr. Bugg\n321 " Int. room 3 cu Russell and 3 men\n322 " Ext. bushes man on\n323 " Int. room 3 cu Russell and 3 men\n324 Pink Ext. bushes man on\n325 " Ext. cottage Mary and men come out\n326 " Ext. bushes man on\n327 " Ext. cottage Mary and men on\n328 " Ext. bushes man on\n329 " Ext. cottage Mary and Russell go off in car - F.O.\n\n3. T. 102 B.W. While at the\n330 " Int. room F.I. Robert and Ford\n3. T. 103 " You're a fine\n331 " Int. room on 2 Ford\n332 " Int. " on Robert\n333 " Int. " King on\n334 " Int. " on Ford\n3. T. 104 " I wish I\n335 " Int. room on Ford\n336 " Int. " on Robt.\n3. T. 105 " So do I\n337 " Int. room on Robt\n338 " Int. hall man comes on
s1229l17205	5	THE LADY FROM LONGACRE\nRHEL # 2\n\n121 Pink\n122 ns.49- " Int. room Russell and Molly on\n122 " Page bearer\n123 " Int. room cu Russell\n124 " Int. " cu Molly\n125 " Int. " cu Russell\n126 " Int. " cu Molly\n126 " Int. " cu Russell\n127 " Never you mind\n127 " Int. room cu Molly\n128 " I am no such\n128 " Int. room Russell and Molly on\n129 " Marriage certificate\n129 " Int. room Russell and Molly on\n130 " Don't worry\n130 " Int. room Russell and Molly on\n131 " Int. " Russell and Molly on - fade\n131 " That evening - along\n132 " Fade in Ext. street Princess in back\n133 " Ext. street cu Princess\n133 " Two mysterious\n134 " Ext. street cu 2 men enter\n135 " That's she\n135 " Ext. street cu 2 men\n136 " Ext. " cu Princess\n137 " Ext. " cu 2 men\n138 " Ext. " Princess to f.g. - 2 men behind\n139 " Ext. theatre car to f.g. - Russell out\n140 " Ext. " cu Russell and Molly\n140 " I'll make another\n141 " Ext. theatre Russell and Molly talk - 1 exits\n142 " Ext. Russell gets in car - exits\n143 " Ext. street Princess to b.g. - 2 men grab her\n144 " Ext. " auto enters\n145 " Ext. " 2 men hold Princess\n146 " Ext. Russell gets out of auto\n147 " Ext. men hold Princess - Russell and Tiger enter\n148 " Ext. street Russell and men fight\n149 " Ext. " cop to f.g.\n150 " Ext. " Russell, Tiger and men fight\n151 " Ext. " cop exits\n152 " Ext. Russell and people - exit with Princess\n153 " Ext. Russell and Princess gets in auto\n154 " Ext. street Tiger and men fight\n155 " Int. auto cu Princess and Russell talk\n156 " Ext. street Tiger on - cop enters\n157 " Ext. " cu 2 men\n158 " Ext. " cu cop and Tiger\n158 " Well if it\n159 " Ext. street cu cop and Tiger talk\n160 " Int. auto cu Princess and Russell\n161 " Ext. street cu cop and Tiger\n162 " Ext. " cu 2 men\n163 " Int. auto cu Princess and Russell\n163 " I thank you\n164 " Int. auto cu Princess and Russell talk\n165 " Would you mind\n165 " Int. auto cu Princess and Russell talk\n166 " Fade in Ext. street - auto enters\n167 " Ext. cu man by wall\n168 " Ext. Russell on - Princess out of auto
s1229l17205	3	THE LADY FROM LONGACRE\nREEL # 1\n\nS.T.17 B.W.\n41 Int. room Fade - Ford and Robert on\n42 Marquis de Freitas\n43 Int. room on Ford\n44 Count de Se, lato\n45 Int. room on Robert\n46 Int. " on Ford\n47 This is terrible\n48 Int. room Ford and Bob on - Jean enters\n49 Ext-King Peire\n50 Int. room Jean on\n51 Int. " on Ford\n52 Int. " on Bob\n53 Int. " on Jean\n54 Int. " Ford, Jean and Bob on\n55 Int. " Ford and Jean on\n56 Nice mess you've\n57 Int. room Ford and Jean on\n58 Why, it was\n59 Int. room Ford and Jean on\n60 Int. " Ford, Jean and Bob on\n61 Int. room Ford and Jean on\n62 I don't want\n63 Int. room on Jean\n64 Int. " on Ford\n65 Oh you don't eh?\n66 Int. room on Ford\n67 Int. " on Jean\n68 I'm tired of this\n69 Int. room on Jean\n70 Int. " on Ford\n71 Int. " on Bob\n72 Int. " on Ford\n73 You know it\n74 Int. room Ford and Jean on\n75 Int. " on Bob\n76 Int. " Ford and Jean on\n77 You'll never get\n78 Int. room Ford and Jean on\n79 Int. " on Bob\n80 If I am her uncle\n81 Int. room on Bob exits\n82 Int. " Ford and Jean on - Bob enters\n83 That you may not\n84 Int. room Ford, Jean and Bob on - fade\n85 At the home\n86 Int. room Fade - Aunt, girl and man on\n87 In the family\n88 Int. room Aunt, Laura and Charles on\n89 Int. " Russell enters\n90 Int. " Aunt, Laura and Charles on\n91 Int. " Russell on\n92 Int. " Aunt, Laura and Charles on\n93 Russell on - he exit\n94 Ext. " Aunt, Laura and Charles on - Russell enters\n95 Int. " Russell and Aunt on\n96 Well Tony ---- we've\n97 Int. room Russell and Aunt on\n98 Let's see ---- already\n99 Int. room Russell and Aunt on\n100 ---- I'm afraid
s1229l17205	1	©CIL 17205\n\nNOV 19 1921\n\nTHE LADY FROM LONGACRE.\nPhotoplay In Five Parts.\n\nStory by\nVictor Bridges\n\nScenario by\nPaul Schofield\n\nDirected by\nGeorge E. Marshall\n\nfor\n\nTHE FOX FILM CORPORATION\nWILLIAM FOX.\nPresident\n\nCopyright\n1921.\n\nWilliam Fox.
s1229l17205	16	THE LADY FROM LONGACRE\nREEL # 5\n\n635 B.W. Int. room Molly and Mary on\n636 Yellow Ext. palace Russell in tree - soldiers watch\n637 B.W. Int. " Molly at window\n638 " Int. " Mary at door\n639 Yellow Ext. " Russell on tree\n640 " Ext. " soldiers on\n641 " Ext. " Russell on tree\n642 " Ext. " soldiers on\n643 B.W. Int. room Russell enters window - Molly on\n644 " Int. palace 3 men enter\n645 " Int. room Molly and Russell on - Mary enters\n646 Yellow Ext. palace soldiers on\n647 B.W. Int. room Molly, Mary and Russell on\n648 " Int. palace soldiers and Ford at door\n649 " Int. room Molly, Mary and Russell on - soldiers enter\n650 " Int. " soldiers grabm Russell - Ford on\n651 " Int. " cu Molly\n652 " Int. " cu Ford\n653 S.T.163 " You and your\n654 " Int. room Russell talking to Ford - others on\n655 " Int. room I dare you to\n656 " Int. room cu Ford\n657 Yellow Ext. " Harow them out\n658 " Ext. " soldiers exit with Russell and Mary\n659 " Ext. palace soldiers taking Russell and Mary out\n660 " Ext. " soldiers put Russell and Mary in auto\n661 " Ext. " Russell and Mary in auto\n662 S.T.165-A " Thank you\n663 " Ext. palace Russell and Mary exit in auto-soldiers on\n664 S.T.166 B.W. After the wedding\n665 " Int. palace soldiers on\n666 Yellow Ext. road auto on\n667 " Ext. " cu Russell and Mary\n668 " It's all right\n669 " Ext. road cu Russel, Mary takes off wig off\n670 S.T.168 B.W. While the Prince\n671 " Int. palace Ford kisses Molly's hand\n672 " Int. " cu Pedro\n673 " Int. " cu Molly\n674 S.T.169 " You and the cabinet\n675 " Int. palace cu Ford and Molly talking\n676 S.T.170 " Well, you see\n677 " Int. palace cu Molly\n678 " Int. " cu Pedro\n679 " Int. " cu Molly\n680 S.T.171 " Don't you know me\n681 " Int. palace Ford and Molly talking\n682 " Int. " cu Peiro\n683 " Int. " Molly takes off veil - Peiro and Ford on\n684 S.T.172 " Molly\n685 " Int. palace Ford and soldiers exit-Peiro and Molly embrace\n686 " Ext. road cu Mary and Russell\n687 S.T.173 " Since you are a\n688 " Ext. road cu Mary and Russell\n689 S.T.174 " My husband --- I\n690 " Ext. road cu Mary and Russell kiss - fade\n\nTHE END.
s1229l17205	11	THE LADY FROM LONGACRE\nREEL 6\n\n385\n386\n387\n388\n389\n390\n391\n392\n393\n394\n395\n396\n397\n398\n399\n400\n401\n402\n403\n404\n405\n406\n407\n408\n409\n410\n411\n412\n413\n414\n415\n416\n417\n418\n419\n420\n421\n422\n423\n424\n425\n426\n427\n428\n429\n430\n431\n\nB.W.\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n"\n\nInt. room cu couple exit\nInt. " couple enter to Russell, aunt and Mary\nDo you happen\nInt. room cu couple\nInt. " cu Mary\nInt. " cu couple\nInt. " cu Russell\nInt. " cu Mary\nInt. " cu Russell\nInt. " cu Mary\nInt. " people on\nTell her Auntie\nInt. room cu Mary, aunt and Russell\nMy dear Laura\nInt. room cu woman\nInt. " cu man\nInt. " cu Mary\nInt. " people on - some exit - F.O.\nMolly learns of\nInt. fade in cu Russell and Molly\nInt. cu Russell\nInt. cu Molly\nShe must\nInt. cu Molly\nInt. cu Russell\nThe papers\nInt. cu Russell\nInt. cu Molly\nOh but I'd\nInt. cu Russell and Molly\nWhat does she\nInt. cu Russell and Molly\nExcept for\nInt. cu Russell and Molly\n---- and so demure\nInt. cu Russell\nInt. cu Molly\nTony ---- I believe\nInt. cu Russell and Molly\nExt. Buck on - Mary and woman enter\nSir Anthony's\nExt. Buck, Mary and woman exit\nExt. Mary, Buck and others to auto\nExt. cu Mary into auto\nExt. cu man by auto\nExt. Buck and man fight by auto\nInt. cu Mary in auto\nExt. cu man opens door in auto\nInt. cu Mary in auto\nExt. cu man into auto\nExt. Buck fights with man - auto exits\nExt. Buck, woman and maid\nInt. auto cu man holding Mary\nExt. Buck exits - woman and maid to b.g.\nInt. auto cu man and Mary\nInt. Buck enters to phone - others enter\nInt. Russell and Molly-Maid enters to phone-Russell to phone\nInt. Buck at phone - woman and others on\nInt. Russell at phone - Molly on
s1229l17205	7	THE LADY FROM LONGACRE\nREEL # 2\n\n216 Amber\n217 " Int. room cu Lord, Russell and Princess\n218 " Int. " Russell enters to picture\n219 " Int. " cu photo\n220 " Int. " cu Russell with photo\n221 " Int. " cu photo\n221 " Int. " Russell to Princess\nS. T. 74 " No wonder they\n222 " Int. room Russell and Princess talk\n223 " Int. " cu photo\n224 " Int. " Russell and Princess - she exits\n225 " Int. " Russell and Princess\nS. T. 75 " Telephone to your\n226 " Int. room cu butler and Russell\n227 " Int. " Russell, Princess and butler\n228 " Int. room lady at phone\n229 " Int. " Russell, Princess and butler - fade\nS. T. 76 " The cottage of\n230 " Fade in Int. hall people enter\n231 " Int. hall cu lady\n232 " Int. " cu Princess and Russell\n233 " Int. " Russell and people\n234 " Int. " cu lady\n235 " Int. " cu butler\n236 " Int. " cu lady\n237 " Int. " cu butler exits\n238 " Int. " Russell and Princess\nS. T. 77 " You can remain\n239 " Int. hall Russell and Princess talk\nS. T. 78 " I am without\n240 " Int. hall Russell and Princess\n241 " Int. " cu jewelry\n242 " Int. " cu Princess and Russell\nS. T. 79 " Now please\n243 " Int. hall cu Princess and Russell\nS. T. 80 " How don't be\n244 " Int. hall cu Russell and Princess - fade\n\nEND OF REEL TWO
s1229l17205	17	This document is from the Library of Congress\n“Motion Picture Copyright Descriptions Collection,\n1912-1977”\n\nCollections Summary:\nThe Motion Picture Copyright Descriptions Collection, Class L and Class M, consists of forms, abstracts,\nplot summaries, dialogue and continuity scripts, press kits, publicity and other material, submitted for the\npurpose of enabling descriptive cataloging for motion picture photoplays registered with the United States\nCopyright Office under Class L and Class M from 1912-1977.\n\nClass L Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi020004\n\nClass M Finding Aid:\nhttps://hdl.loc.gov/loc.mbrsmi/eadmbrsmi.mi021002\n\nAUDIO-VISUAL CONSERVATION\nat The LIBRARY of CONGRESS\n\nNational Audio-Visual Conservation Center\nThe Library of Congress
s1229l17205	15	S.T.159 Yellow\n582\n582*\nS.T1160\n583\n584\n585\n586\nB.W.\n587\n588\n589\n590\n591\n592\n593\n594\n595\n596\nS.T.161\n597\n598\n599\n600\n601\n602\n603\n604\n605\n606\n607\n608\n609\n610\n611\n612\n613\n614\n615\n616\n617\nS.T.162\n618\n619\n620\n621\n622\n623\n624\n625\n626\n627\n627*\n628\nYellow\n629\n630\n631\nB.W.\n632\nYellow\n633\nB.W.\n634\n\nLADY OF LONGACHS\nREEL # 8\n\nI am Lord Charles\nExt. palace on Charles and Tiger\nExt. " on Ford - soldiers enter\nGuard these two\nExt. palace Ford and soldier on\nExt. " Pedro and Robt watch\nExt. " Ford and others exit-soldier after Tiger & Charles\nInt. room Mary and Molly changing\nInt. palace soldiers on - Ford enters\nInt. " Russell talking to soldiers in b.g.\nInt. " Ford and soldiers look\nInt. " on Russell turns\nInt. " Ford and soldier on\nInt. " on Russell\nInt. " Ford exits in b.g. - soldiers on\nInt. " Russell on - Ford enters - soldiers on\nInt. room Molly and Mary changing\nInt. palace Ford talks to Russell - soldiers on\nIf this is another\nInt. palace Ford exits -soldiers and Russell on\nInt. " Russell jumps on stairs - grabs Ford\nInt. " Pedro watches\nInt. " Russell takes Ford's sword\nInt. " Russellx fighting soldiers\nInt. room Mary and Molly on\nInt. palace Russell fighting soldiers\nInt. room Molly and Mary on\nInt. palace Russell fighting soldiers\nInt. room Molly to door - Mary on\nInt. palace Russell fighting soldiers\nInt. room on Molly at door\nInt. palace Russell fighting soldiers\nInt. room on Molly at door\nInt. " on Mary\nInt. " on Molly at door\nInt. palace Russell fighting soldiers\nInt. room on Molly at door\nInt. palace Russell fighting soldiers\nInt. room Molly at door\nInt. palace Russell fighting soldiers\nTake him alive\nInt. palace Russell, fighting soldiers in b.g.\nInt. room Mary and Molly on\nInt. palace Russell fighting soldiers\nInt. room on Molly at door\nInt. " Russell fighting soldiers\nInt. " Molly at door\nInt. " on Mary\nInt. " on Mary\nInt. " Russell runs - soldiers after him\nInt. " soldiers after Russell\nInt. " soldiers after Russell\nInt. " Russell enters - fights soldiers by auto\nExt. " Russell enters\nExt. " Tiger choking soldier - soldiers enter\nInt. " soldiers at door\nExt. " Russell to tree\nInt. room Molly and Mary on\nInt. palace soldiers at door
s1229l17205	2	THE LADY FROM LONDCARES\nREEL # 1 #807\n\nS.T.1 B.V.\nS.T.2 "\nS.T.3 "\nS.T.4 "\nS.T.5 "\n1\nS.T.6 "\n2\n3\n4\n5\n6\nS.T.7 "\n7\n8\n9\nS.T.8 "\n10\n11\n12\n13\nS.T.9 "\n14\nS.T.10 "\n15\nS.T.11 "\n16\n17\n18\n19\n20\n21\n22\nS.T.12 "\n23\n24\nS.T.13 "\n25\n26\n27\nS.T.14 "\n28\n29\n30\n31\n32\nS.T.15 "\n33\n34\n35\nS.T.16 "\n36\n37\n38\n39\n40\n\nWilliam Fox presents William Russell\nPassed by National Board of Review\nCopyright William Fox\nDirected by George E. Marshall\nStory by Victor Bridges\nScenario by Paul Schofield\nPhotography by Bennie Kline and\nIn dear old London.\nInt. room Fade - Russell in chair - horse on\nSir Anthony Conway\nInt. room Russell on\nInt. " on horse head\nInt. " Russell on\nInt. " on horse head\nInt. " Russell and horse on\nTiger Bugg ---- his\nInt. room Tiger in bed\nInt. " Russell and horse on\nInt. " Tiger in bed\nLook out 99-- x or\nInt. room Tiger in bed\nInt. " Russell and horse on\nInt. " Tiger on - exits\nInt. " Russell and horse on - Tiger enters\nI say gov'nor\nInt. room Tiger, Russell and horse on\nI remember now\nInt. room Russell, Tiger and horse on\nRighto gov'nor\nInt. room Russell, Tiger and horse on\nInt. " man enters\nInt. " on horse, Russell and Tiger\nInt. " man on\nInt. " on Russell and Tiger\nInt. " man on\nInt. " Russell, Tiger on - man enters\nWhat the devil\nInt. room cu Russell\nInt. " cu man\nBut, sir ---- I\nInt. room cu man\nInt. " Tiger on\nInt. " cu Russell\nVery well, I'll\nInt. room Russell on\nInt. " cu man\nInt. " cu Russell\nInt. " cu Tiger\nInt. " Russell, Tiger and man on\nPlease sir ---- Lady\nInt. room cu man\nInt. " cu Russell\nInt. " Russell, Tiger and man on\nOh Lord ---- Aunt\nInt. room Russell, Tiger and man on\nInt. " cu man\nInt. " cu Tiger\nInt. " cu man\nInt. " Russell, Tiger and man on - fade
s1229l17205	12	LADY FROM LONGACRE\nREEL # 4\n\n432 Pink\nInt. Suck at phone - others on\n433 "\nInt. Russell and Molly exit\n434 "\nInt. Suck to b.g. - maid and woman on\n435 "\nInt. auto cu man and Mary\n436 "\nInt. people on\n437 "\nInt. auto cu man and Mary\n438 "\nInt. people on - Russell enters\n439 "\nInt. cu auto - man and Mary on\n440 "\nInt. Russell and others on\n441 "\nInt. cu Russell and Molly\n442 "\nInt. auto cu Man and Mary\n443 "\nInt. cu Russell and Mary\n8. T. 130 "\n---- be sure\n444 "\nInt. Russell and Molly\n445 "\nInt. Molly exits - Russell and others on\n446 "\nExt. deck cu men on - man and Mary enter - fade\n8. T. 131 Yellow\n447 "\nThree o'clock\n448 "\nExt. deck Russell, Bugg and sailors on\n449 "\nExt. deck Mary and King on\n8. T. 132 "\nI know you\n450 "\nExt. deck Mary and King\n451 "\nExt. cu 2 men\n452 "\nExt. deck cu Mary and King\n453 "\nExt. deck Russell and others\n454 "\nExt. Minister enters\n455 "\nExt. deck Russell and others\n456 "\nExt. Minister exits\n457 "\nExt. deck Russell on - Minister enters\n458 "\nExt. deck cu Mary and King\n459 "\nExt. cu Russell, Minister and others\n8. T. 133 "\nExt. Russell and others to boat - fade\n460 "\nAt the castle\n461 "\nExt. fade - castle - soldiers on\n462 "\nInt. Mary and men on\n8. T. 134 "\nInt. cu man\n463 "\nDo you not\n464 "\nInt. cu man\n465 "\nInt. cu Mary\n466 "\nInt. cu man\n467 "\nInt. cu Mary\n8. T. 135 "\nInt. room Mary, Ford and Kline\n468 "\nMust Pedro\n8. T. 136 "\nInt. cu Mary and Ford\n469 "\nNo way\n470 "\nInt. cu Mary\n8. T. 137 "\nInt. cu Mary, Ford and Kline\n471 "\nUpon this\n472 "\nInt. cu Ford\n473 "\nInt. cu Mary\n474 "\nInt. cu bird in cage\n475 "\nInt. cu Mary\n476 "\nInt. cu Kline\n477 "\nInt. cu Ford\n478 "\nInt. cu Mary\n8. T. 138 "\nI will not\n479 Yellow\nInt. cu Mary, Ford and Kline\nExt. river Russell and others get out from boat - get on\nshore
s1229l17205	13	THE LADY FROM LONGACRE\nREEL # 4\n\n480  B.W.  Int. Ford and Kline exit - Mary on - fade\n481  Yellow  Ext. fade in castle\n482  B.W.  Int. castle soldiers on-dissoly to cu officers and men\n483  S. T. 139  "  Count does\n484  "  Int. cu officer and men\n485  "  Int. Mary and woman\n486  "  Int. cu Mary\n487  S. T. 140  "  If people\n488  "  Int. Mary and woman\n489  Yellow  Ext. castle Russell enters in auto\n490  "  Ext. " cu Russell and others in auto\n491  "  Ext. " cu Russell gives soldier card-minister on\n492  "  Card: pass bearer\n493  "  Ext. Russell, Minister in auto - soldiers on\n494  "  Ext. cu Russell talking to men in auto\n495  S. T. 142  "  Don't forget\n496  "  Ext. Russell in auto - gets up\n497  "  Ext. castle Russell and minister exit\n498  B.W.  Int. " soldiers on - Russell and minister enter\n499  "  Int. " cu Russell and Minister\n500  "  Int. " man and officers at table\n501  "  Int. Russell and Minister on\n502  "  Int. castle man and officers on\n503  "  Int. " Russell and minister\n504  "  Int. " officer to f.g. - Others on\n505  "  Int. cu Jones and Minister\n506  "  Int. castle Jones, Minister and soldiers\n507  "  Int. Mary and woman on\n508  "  Int. cu Russell and Minister to officer\n509  S. T. 143  "  This is the\n510  "  Int. cu Russell, Minister and officer\n511  "  Int. cu Minister\n512  "  Int. cu officer\n513  "  Int. Russell, Minister and officer\n514  "  Int. Mary and woman\n515  "  Int. Russell, Minister and officer\n516  "  Int. cu stairs - man exits\n517  "  Int. Russell, Minister and officer\n518  "  Int. cu woman opens door - man on\n519  "  Int. cu Mary\n520  "  Int. cu woman - man at door\n521  S. T. 144  "  The Reverend\n522  "  Int. cu woman\n523  "  Int. cu man\n524  "  Int. room Mary on - woman at door\n525  "  Ext. officer in auto\n526  Yellow  Int. cu Russell, officer and Minister\n527  B.W.  Int. cu man on stairs\n528  "  Int. Minister exits - Russell and officer\n529  "  Int. Minister and man up stairs\n530  "  Int. Russell and officer\n531  "  Int. Minister on stairs\n532  "  Int. Russell and officer sit down\n533  Yellow  Ext. officers in auto\n534  B.W.  Int. room Mary and woman on - Minister enters\n535  "  Int. cu Minister\n536  "  Int. cu Mary\n537  "  Int. Mary and Minister\n538  "  Int. Russell and officer\n539  "  Ext. officers in auto\n\nEND OF REEL FOUR
s1229l17205	10	THE LADY FROM LONGACRE\nREEL 3\n\n339 B.W. Int. room Robt and Ford on - King in b.g.\n340 " Int. " Ford enters to door\n341 " Int. " on King\n342 " Int. " Ford opening door\n343 " Int. hall man on - goes in\n344 " Int. room on Ford and man\n3. 2. 106 " Sir Anthony took\n345 " Int. room on Ford and man\n346 " Int. " on King\n347 " Int. " on Ford and man\n348 " Int. " on King\n349 " Int. " on Ford and man\n350 " Int. " 3 on Ford and men - 1 exits\n351 " Int. " on King comes f.g. - exits\n352 " Int. " Ford, Robt and King on - Ford stops King\n353 " Int. " on Ford and King\n3. 2. 107 " You forget who\n354 " Int. room on King\n355 " Int. " on Ford\n3. 2. 108 " I haven't forgotten\n356 " Int. room on Ford\n357 " Int. " on King\n3. 2. 109 " You shall not\n358 " Int. room on Ford and King\n359 " Int. " on Robt\n360 " Int. " on Ford\n3. 2. 110 " Your wife\n361 " Int. room on Ford\n362 " Int. " on King\n363 " Int. " on Ford\n3. 2. 111 " We'll annul\n364 " Int. room on Ford and King\n365 " Int. " on Robt\n366 " Int. " Ford, Robt and King on\n367 " Int. hall messenger comes on\n368 " Int. room on Ford\n369 " Int. " on Robt\n370 " Int. " Ford opening door\n371 " Int. hall messenger on\n372 " Int. room Ford and Robt on - letter gets message\n373 " Int. " on Robt - Ford enters\nIns. 112 " Upon announcement\n374 " Int. room on Robt and Ford\n3. 2. 113 " Cable a reply\n375 " Int. room on Robt and Ford - F.O.\n3. 2. 114 " Tony explains\n376 " Int. room F.I. Russell, aunt and Mary\n3. 2. 115 " " " and I know\n377 " Int. room on Russell and aunt\n378 " Int. " on Mary\n379 " Int. " on Russell and aunt\n380 " Int. " Russell, Mary and aunt on\n381 " Int. " couple enter\n382 " Int. " Mary, Russell and aunt on\n383 " Int. " on couple\n384 " Int. " Mary, Russell and aunt on\n\nEND OF REEL THREE
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: deh
--

COPY public.users (name, email, encoded_password) FROM stdin;
\.


--
-- Data for Name: view_history; Type: TABLE DATA; Schema: public; Owner: deh
--

COPY public.view_history (id, document_id, user_name, viewed_at, search_id) FROM stdin;
\.


--
-- Name: search_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: deh
--

SELECT pg_catalog.setval('public.search_history_id_seq', 66, true);


--
-- Name: view_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: deh
--

SELECT pg_catalog.setval('public.view_history_id_seq', 68, true);


--
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: deh
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: text_search_view; Type: MATERIALIZED VIEW; Schema: public; Owner: deh
--

CREATE MATERIALIZED VIEW public.text_search_view AS
 SELECT documents.id AS document_id,
    (setweight(to_tsvector(COALESCE(documents.title, ''::text)), 'A'::"char") || setweight(to_tsvector(COALESCE(text_content_view.content, ''::text)), 'B'::"char")) AS text_vector
   FROM public.documents,
    public.text_content_view
  WHERE ((documents.id)::text = (text_content_view.document_id)::text)
  GROUP BY documents.id, text_content_view.content
  WITH NO DATA;


ALTER MATERIALIZED VIEW public.text_search_view OWNER TO deh;

--
-- Name: actors actors_pkey; Type: CONSTRAINT; Schema: public; Owner: deh
--

ALTER TABLE ONLY public.actors
    ADD CONSTRAINT actors_pkey PRIMARY KEY (name);


--
-- Name: error_locations error_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: deh
--

ALTER TABLE ONLY public.error_locations
    ADD CONSTRAINT error_locations_pkey PRIMARY KEY (location);


--
-- Name: flagged_by flagged_by_pkey; Type: CONSTRAINT; Schema: public; Owner: deh
--

ALTER TABLE ONLY public.flagged_by
    ADD CONSTRAINT flagged_by_pkey PRIMARY KEY (id);


--
-- Name: genres genres_pkey; Type: CONSTRAINT; Schema: public; Owner: deh
--

ALTER TABLE ONLY public.genres
    ADD CONSTRAINT genres_pkey PRIMARY KEY (genre);


--
-- Name: has_character has_character_pkey; Type: CONSTRAINT; Schema: public; Owner: deh
--

ALTER TABLE ONLY public.has_character
    ADD CONSTRAINT has_character_pkey PRIMARY KEY (id);


--
-- Name: has_genre has_genre_pkey; Type: CONSTRAINT; Schema: public; Owner: deh
--

ALTER TABLE ONLY public.has_genre
    ADD CONSTRAINT has_genre_pkey PRIMARY KEY (document_id, genre);


--
-- Name: has_location has_location_pkey; Type: CONSTRAINT; Schema: public; Owner: deh
--

ALTER TABLE ONLY public.has_location
    ADD CONSTRAINT has_location_pkey PRIMARY KEY (id);


--
-- Name: search_history search_history_pkey; Type: CONSTRAINT; Schema: public; Owner: deh
--

ALTER TABLE ONLY public.search_history
    ADD CONSTRAINT search_history_pkey PRIMARY KEY (id);


--
-- Name: transcripts transcripts_pkey; Type: CONSTRAINT; Schema: public; Owner: deh
--

ALTER TABLE ONLY public.transcripts
    ADD CONSTRAINT transcripts_pkey PRIMARY KEY (document_id, page_number);


--
-- Name: users unique_email; Type: CONSTRAINT; Schema: public; Owner: deh
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT unique_email UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: deh
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (name);


--
-- Name: view_history view_history_pkey; Type: CONSTRAINT; Schema: public; Owner: deh
--

ALTER TABLE ONLY public.view_history
    ADD CONSTRAINT view_history_pkey PRIMARY KEY (id);


--
-- Name: idx_actor; Type: INDEX; Schema: public; Owner: deh
--

CREATE INDEX idx_actor ON public.has_character USING btree (actor_name);


--
-- Name: idx_copyright_year; Type: INDEX; Schema: public; Owner: deh
--

CREATE INDEX idx_copyright_year ON public.documents USING btree (copyright_year);


--
-- Name: idx_has_character_document_id; Type: INDEX; Schema: public; Owner: deh
--

CREATE INDEX idx_has_character_document_id ON public.has_character USING btree (document_id);


--
-- Name: idx_has_location_document_id; Type: INDEX; Schema: public; Owner: deh
--

CREATE INDEX idx_has_location_document_id ON public.has_location USING btree (document_id);


--
-- Name: idx_search_history_user_time; Type: INDEX; Schema: public; Owner: deh
--

CREATE INDEX idx_search_history_user_time ON public.search_history USING btree (user_name, "time" DESC);


--
-- Name: idx_studio; Type: INDEX; Schema: public; Owner: deh
--

CREATE INDEX idx_studio ON public.documents USING btree (studio);


--
-- Name: idx_title; Type: INDEX; Schema: public; Owner: deh
--

CREATE INDEX idx_title ON public.documents USING btree (title);


--
-- Name: idx_view_history_search_id; Type: INDEX; Schema: public; Owner: deh
--

CREATE INDEX idx_view_history_search_id ON public.view_history USING btree (search_id);


--
-- Name: idx_view_history_user_time; Type: INDEX; Schema: public; Owner: deh
--

CREATE INDEX idx_view_history_user_time ON public.view_history USING btree (user_name, viewed_at DESC);


--
-- Name: has_character fk_actor_name; Type: FK CONSTRAINT; Schema: public; Owner: deh
--

ALTER TABLE ONLY public.has_character
    ADD CONSTRAINT fk_actor_name FOREIGN KEY (actor_name) REFERENCES public.actors(name);


--
-- Name: flagged_by fk_document_id; Type: FK CONSTRAINT; Schema: public; Owner: deh
--

ALTER TABLE ONLY public.flagged_by
    ADD CONSTRAINT fk_document_id FOREIGN KEY (document_id) REFERENCES public.documents(id);


--
-- Name: has_character fk_document_id; Type: FK CONSTRAINT; Schema: public; Owner: deh
--

ALTER TABLE ONLY public.has_character
    ADD CONSTRAINT fk_document_id FOREIGN KEY (document_id) REFERENCES public.documents(id);


--
-- Name: has_genre fk_document_id; Type: FK CONSTRAINT; Schema: public; Owner: deh
--

ALTER TABLE ONLY public.has_genre
    ADD CONSTRAINT fk_document_id FOREIGN KEY (document_id) REFERENCES public.documents(id);


--
-- Name: has_location fk_document_id; Type: FK CONSTRAINT; Schema: public; Owner: deh
--

ALTER TABLE ONLY public.has_location
    ADD CONSTRAINT fk_document_id FOREIGN KEY (document_id) REFERENCES public.documents(id);


--
-- Name: transcripts fk_document_id; Type: FK CONSTRAINT; Schema: public; Owner: deh
--

ALTER TABLE ONLY public.transcripts
    ADD CONSTRAINT fk_document_id FOREIGN KEY (document_id) REFERENCES public.documents(id);


--
-- Name: view_history fk_document_id; Type: FK CONSTRAINT; Schema: public; Owner: deh
--

ALTER TABLE ONLY public.view_history
    ADD CONSTRAINT fk_document_id FOREIGN KEY (document_id) REFERENCES public.documents(id);


--
-- Name: flagged_by fk_error_location; Type: FK CONSTRAINT; Schema: public; Owner: deh
--

ALTER TABLE ONLY public.flagged_by
    ADD CONSTRAINT fk_error_location FOREIGN KEY (error_location) REFERENCES public.error_locations(location);


--
-- Name: has_genre fk_genre; Type: FK CONSTRAINT; Schema: public; Owner: deh
--

ALTER TABLE ONLY public.has_genre
    ADD CONSTRAINT fk_genre FOREIGN KEY (genre) REFERENCES public.genres(genre);


--
-- Name: documents fk_uploaded_by; Type: FK CONSTRAINT; Schema: public; Owner: deh
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT fk_uploaded_by FOREIGN KEY (uploaded_by) REFERENCES public.users(name);


--
-- Name: flagged_by fk_user_name; Type: FK CONSTRAINT; Schema: public; Owner: deh
--

ALTER TABLE ONLY public.flagged_by
    ADD CONSTRAINT fk_user_name FOREIGN KEY (user_name) REFERENCES public.users(name);


--
-- Name: search_history fk_user_name; Type: FK CONSTRAINT; Schema: public; Owner: deh
--

ALTER TABLE ONLY public.search_history
    ADD CONSTRAINT fk_user_name FOREIGN KEY (user_name) REFERENCES public.users(name);


--
-- Name: view_history fk_user_name; Type: FK CONSTRAINT; Schema: public; Owner: deh
--

ALTER TABLE ONLY public.view_history
    ADD CONSTRAINT fk_user_name FOREIGN KEY (user_name) REFERENCES public.users(name);


--
-- Name: view_history fk_view_history_search; Type: FK CONSTRAINT; Schema: public; Owner: deh
--

ALTER TABLE ONLY public.view_history
    ADD CONSTRAINT fk_view_history_search FOREIGN KEY (search_id) REFERENCES public.search_history(id) ON DELETE SET NULL;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: deh
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- Name: text_search_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: deh
--

REFRESH MATERIALIZED VIEW public.text_search_view;


--
-- PostgreSQL database dump complete
--

\unrestrict ShkyrcagrXb5p83WGgru1E602gxw9OGEXbNgXg9HTDrxBYbMhsfaaZM632hiHLI
