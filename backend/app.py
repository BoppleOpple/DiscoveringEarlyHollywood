from flask import Flask, render_template, request, redirect, url_for, session, flash, send_file
from werkzeug.utils import secure_filename
import os
from datetime import datetime
import csv
from io import StringIO

app = Flask(__name__)
app.secret_key = os.environ["FLASK_SECRET"] or os.urandom(20)
app.config['UPLOAD_FOLDER'] = 'uploads'
app.config['MAX_CONTENT_LENGTH'] = 50 * 1024 * 1024  # 50MB max file size

# Ensure upload folder exists
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

# Mock document data
DOCUMENTS = [
    {
        "id": 1,
        "title": "Sunset Boulevard",
        "description": "Copyright registration documents for the classic film noir about a screenwriter and a faded silent film star.",
        "year": "1950",
        "documentType": "Copyright Registration",
        "fullDescription": "Sunset Boulevard is a classic American film noir that tells the story of Joe Gillis, a struggling screenwriter, who becomes entangled with Norma Desmond, a faded silent film star living in the past. The film is a dark and cynical examination of Hollywood's treatment of aging stars and the price of fame. Directed by Billy Wilder, the film received widespread critical acclaim and is considered one of the greatest films ever made. The narrative unfolds through flashback as Joe's dead body is discovered floating in Norma's swimming pool, creating a haunting and unforgettable cinematic experience.",
        "studio": "Paramount Pictures",
        "genre": "Film Noir / Drama",
        "director": "Billy Wilder",
        "actors": ["Gloria Swanson", "William Holden", "Erich von Stroheim", "Nancy Olson"],
        "runtime": "110 minutes",
        "language": "English",
        "flags": [
            {
                "id": 1,
                "user": "Dr. Sarah Mitchell",
                "reason": "Document appears to have incorrect filing date. Should be cross-referenced with studio records.",
                "date": "Nov 15, 2025"
            },
            {
                "id": 2,
                "user": "James Rodriguez",
                "reason": "Missing signature on page 3 of the copyright registration form.",
                "date": "Nov 12, 2025"
            },
            {
                "id": 3,
                "user": "Emily Chen",
                "reason": "Potential discrepancy in the listed production company name.",
                "date": "Nov 10, 2025"
            }
        ]
    },
    {
        "id": 2,
        "title": "The Jazz Singer",
        "description": "Historic copyright filing for the first feature-length motion picture with synchronized dialogue sequences.",
        "year": "1927",
        "documentType": "Copyright Registration",
        "fullDescription": "The Jazz Singer revolutionized the film industry as the first feature-length motion picture with synchronized dialogue sequences, effectively marking the end of the silent film era. The film tells the story of Jakie Rabinowitz, a young man torn between his Jewish heritage and his dreams of becoming a jazz singer. When he defies his father, a cantor, to pursue a career in entertainment, he must reconcile his love for modern music with his family's traditional expectations. This groundbreaking film not only introduced sound to cinema but also explored themes of generational conflict, cultural identity, and the American dream.",
        "studio": "Warner Bros.",
        "genre": "Musical Drama",
        "director": "Alan Crosland",
        "actors": ["Al Jolson", "May McAvoy", "Warner Oland", "Eugenie Besserer"],
        "runtime": "88 minutes",
        "language": "English"
    },
    {
        "id": 3,
        "title": "Metropolis",
        "description": "Copyright documentation for Fritz Lang's influential German expressionist science-fiction film.",
        "year": "1927",
        "documentType": "Copyright Registration",
        "fullDescription": "Metropolis is a groundbreaking German expressionist science-fiction film set in a futuristic dystopian city where society is divided between the wealthy industrialists who live in luxury skyscrapers and the oppressed workers who toil in underground factories. The film follows Freder, the son of the city's mastermind, as he falls in love with Maria, a working-class prophet who preaches peace between the classes. With its stunning visual effects, elaborate sets, and powerful social commentary, Metropolis has influenced countless films and remains a masterpiece of early cinema.",
        "studio": "UFA (Universum Film AG)",
        "genre": "Science Fiction / Drama",
        "director": "Fritz Lang",
        "actors": ["Brigitte Helm", "Gustav Fröhlich", "Alfred Abel", "Rudolf Klein-Rogge"],
        "runtime": "153 minutes",
        "language": "Silent (German intertitles)",
        "flags": [
            {
                "id": 4,
                "user": "Prof. Heinrich Weber",
                "reason": "Translation of German text may be inaccurate. Requires verification by native speaker.",
                "date": "Nov 14, 2025"
            },
            {
                "id": 5,
                "user": "Anna Foster",
                "reason": "Document quality is poor - some text illegible. May need restoration or alternative source.",
                "date": "Nov 8, 2025"
            }
        ]
    },
    {
        "id": 4,
        "title": "City Lights",
        "description": "Charlie Chaplin's romantic comedy-drama about a tramp who falls in love with a blind flower girl.",
        "year": "1931",
        "documentType": "Copyright Registration",
        "fullDescription": "City Lights is a silent romantic comedy-drama that showcases Charlie Chaplin's genius as a filmmaker and performer. The story follows the Little Tramp as he falls in love with a blind flower girl and befriends a suicidal millionaire. Determined to help the girl regain her sight, the Tramp embarks on a series of misadventures to raise money for her operation. Despite being released after the advent of sound films, Chaplin insisted on making City Lights as a silent film with a synchronized musical score, demonstrating his commitment to the art form that made him famous. The film's blend of comedy and pathos, culminating in one of cinema's most moving endings, cement its place as one of the greatest films ever made.",
        "studio": "United Artists",
        "genre": "Romance / Comedy",
        "director": "Charlie Chaplin",
        "actors": ["Charlie Chaplin", "Virginia Cherrill", "Florence Lee", "Harry Myers"],
        "runtime": "87 minutes",
        "language": "Silent with music"
    },
    {
        "id": 5,
        "title": "King Kong",
        "description": "Copyright records for the groundbreaking adventure film featuring revolutionary special effects.",
        "year": "1933",
        "documentType": "Copyright Registration",
        "fullDescription": "King Kong is a landmark adventure film that revolutionized special effects and set the standard for monster movies. The story follows filmmaker Carl Denham as he leads an expedition to the mysterious Skull Island, where they encounter the giant ape Kong. When Kong becomes infatuated with actress Ann Darrow, Denham captures him and brings him to New York City as a theatrical attraction. The film's climactic sequence atop the Empire State Building has become one of cinema's most iconic moments. Through groundbreaking stop-motion animation and innovative composite photography, King Kong brought to life a creature that captured audiences' imaginations and spawned countless imitators.",
        "studio": "RKO Radio Pictures",
        "genre": "Adventure / Horror",
        "director": "Merian C. Cooper, Ernest B. Schoedsack",
        "actors": ["Fay Wray", "Robert Armstrong", "Bruce Cabot"],
        "runtime": "100 minutes",
        "language": "English"
    },
    {
        "id": 6,
        "title": "Gone with the Wind",
        "description": "Epic historical romance film set during the American Civil War and Reconstruction era.",
        "year": "1939",
        "documentType": "Copyright Registration",
        "fullDescription": "Gone with the Wind is an epic historical romance that follows the life of Scarlett O'Hara, a strong-willed Southern belle, through the American Civil War and Reconstruction era. Set against the backdrop of the South's transformation, the film chronicles Scarlett's tumultuous relationship with roguish blockade runner Rhett Butler, her obsession with Ashley Wilkes, and her determination to save her family's plantation, Tara. With its sweeping cinematography, elaborate costumes, and memorable performances, Gone with the Wind became one of the highest-grossing films of all time and won eight Academy Awards. The film remains a cultural touchstone, though its romanticized portrayal of the antebellum South has generated significant controversy.",
        "studio": "Metro-Goldwyn-Mayer",
        "genre": "Historical Romance / Drama",
        "director": "Victor Fleming",
        "actors": ["Vivien Leigh", "Clark Gable", "Olivia de Havilland", "Leslie Howard"],
        "runtime": "238 minutes",
        "language": "English",
        "flags": [
            {
                "id": 6,
                "user": "Michael Thompson",
                "reason": "Multiple versions of this document exist in archive. Need to verify which is the original filing.",
                "date": "Nov 13, 2025"
            }
        ]
    }
]

# Mock history data
SEARCH_HISTORY = [
    {"id": 1, "query": "Sunset Boulevard", "date": "Nov 15, 2025"},
    {"id": 2, "query": "Charlie Chaplin", "date": "Nov 14, 2025"},
    {"id": 3, "query": "1927 films", "date": "Nov 12, 2025"},
    {"id": 4, "query": "film noir", "date": "Nov 10, 2025"},
    {"id": 5, "query": "Gone with the Wind", "date": "Nov 8, 2025"}
]

VIEW_HISTORY = [
    {
        "id": 1,
        "title": "Sunset Boulevard",
        "description": "Copyright registration documents for the classic film noir about a screenwriter and a faded silent film star.",
        "year": "1950",
        "documentType": "Copyright Registration",
        "viewedDate": "Nov 15, 2025"
    },
    {
        "id": 4,
        "title": "City Lights",
        "description": "Charlie Chaplin's romantic comedy-drama about a tramp who falls in love with a blind flower girl.",
        "year": "1931",
        "documentType": "Copyright Registration",
        "viewedDate": "Nov 14, 2025"
    },
    {
        "id": 2,
        "title": "The Jazz Singer",
        "description": "Historic copyright filing for the first feature-length motion picture with synchronized dialogue sequences.",
        "year": "1927",
        "documentType": "Copyright Registration",
        "viewedDate": "Nov 12, 2025"
    }
]


@app.route('/')
def index():
    search = request.args.get('search', '')
    genre = request.args.get('genre', '')
    year_min = request.args.get('year_min', 1915)
    year_max = request.args.get('year_max', 1926)
    
    # Filter documents
    filtered_docs = DOCUMENTS
    if search:
        filtered_docs = [d for d in filtered_docs if search.lower() in d['title'].lower() or search.lower() in d['description'].lower()]
    
    return render_template('index.html', documents=filtered_docs, search=search, genre=genre)


@app.route('/document/<int:doc_id>')
def document_detail(doc_id):
    document = next((d for d in DOCUMENTS if d['id'] == doc_id), None)
    if not document:
        flash('Document not found', 'error')
        return redirect(url_for('index'))
    return render_template('document_detail.html', document=document)


@app.route('/history')
def view_history():
    return render_template('view_history.html', 
                         history=VIEW_HISTORY, 
                         searches=SEARCH_HISTORY)


@app.route('/history/download')
def download_history():
    # Create CSV
    output = StringIO()
    writer = csv.writer(output)
    writer.writerow(['Title', 'Year', 'Document Type', 'Description', 'Viewed Date'])
    for doc in VIEW_HISTORY:
        writer.writerow([doc['title'], doc['year'], doc['documentType'], doc['description'], doc['viewedDate']])
    
    # Create response
    output.seek(0)
    return send_file(
        StringIO(output.getvalue()),
        mimetype='text/csv',
        as_attachment=True,
        download_name='viewing-history.csv'
    )


@app.route('/flagged')
def flagged_documents():
    flagged = [d for d in DOCUMENTS if 'flags' in d and len(d['flags']) > 0]
    return render_template('flagged_documents.html', documents=flagged)


@app.route('/manager')
def documents_manager():
    search = request.args.get('search', '')
    docs = DOCUMENTS
    if search:
        docs = [d for d in docs if search.lower() in d['title'].lower() 
                or search.lower() in d.get('studio', '').lower() 
                or search in d['year']]
    return render_template('documents_manager.html', documents=docs, search=search)


@app.route('/login', methods=['POST'])
def login():
    email = request.form.get('email')
    password = request.form.get('password')
    
    # Mock authentication - in production, validate credentials properly
    session['user'] = email
    flash('Successfully logged in!', 'success')
    return redirect(url_for('index'))


@app.route('/signup', methods=['POST'])
def signup():
    email = request.form.get('email')
    password = request.form.get('password')
    full_name = request.form.get('full_name')
    
    # Mock signup - in production, create user in database
    session['user'] = email
    flash('Account created successfully!', 'success')
    return redirect(url_for('index'))


@app.route('/logout')
def logout():
    session.pop('user', None)
    flash('Logged out successfully', 'success')
    return redirect(url_for('index'))


@app.route('/upload', methods=['POST'])
def upload_documents():
    upload_type = request.form.get('upload_type', 'zip')
    
    if upload_type == 'zip':
        zip_file = request.files.get('zip_file')
        if zip_file:
            filename = secure_filename(zip_file.filename)
            zip_file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            flash(f'ZIP file "{filename}" uploaded successfully!', 'success')
    else:
        document_file = request.files.get('document_file')
        metadata_file = request.files.get('metadata_file')
        transcript_file = request.files.get('transcript_file')
        
        files_uploaded = []
        if document_file:
            filename = secure_filename(document_file.filename)
            document_file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            files_uploaded.append(filename)
        if metadata_file:
            filename = secure_filename(metadata_file.filename)
            metadata_file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            files_uploaded.append(filename)
        if transcript_file:
            filename = secure_filename(transcript_file.filename)
            transcript_file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            files_uploaded.append(filename)
        
        if files_uploaded:
            flash(f'Files uploaded: {", ".join(files_uploaded)}', 'success')
    
    return redirect(url_for('documents_manager'))
@app.route("/save_ocr_content", methods=["POST"])
def save_ocr_content():
    """Register a new route for storing transcript data to the database."""
    data = request.get_json()
    image_filename = data["image_filename"]
    updated_ocr_text = data["ocr_text"]

    try:
        ocr_file_path = os.path.join(
            app.config["EDITS_FOLDER"], image_filename + ".txt"
        )
        with open(ocr_file_path, "w", encoding="utf-8") as file:
            file.write(updated_ocr_text)
        return jsonify({"message": "OCR content saved successfully!"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/results", methods=["GET", "POST"])
def results():
    """Register a new route for the ``results`` page of the app."""

    textQuery: str = request.args.get("query", "")

    yearString: str = request.args.get("year", "")
    year: int = int(yearString) if yearString.isnumeric() else None

    page = request.args.get("page", 1, type=int)

    print_kwargs(**request.args)

    query: Query = Query(
        actors=[],  # TODO
        tags=[],  # TODO
        genres=[],  # TODO
        keywords=list(
            filter(lambda s: s != "", textQuery.split(" "))
        ),  # TODO allow searching both titles and transcripts
        documentType=None,  # TODO
        studio=None,  # TODO
        copyrightYearRange=(year, year),  # TODO allow a start & end value
        durationRange=(None, None),  # TODO
    )

    num_results = db_utils.get_num_results(
        dbConnection,
        query,
    )

    results: list[Document] = db_utils.search_results(
        dbConnection,
        query,
        page,
    )

    return render_template(
        "results.html",
        results=results,
        page=page,
        num_pages=math.ceil(num_results / RESULTS_PER_PAGE),
    )


@app.route('/remove', methods=['POST'])
def remove_documents():
    # Get selected document IDs from form
    doc_ids = request.form.getlist('selected_docs')
    
    # Mock removal - in production, remove from database
    flash(f'Removed {len(doc_ids)} document(s) from database', 'success')
    return redirect(url_for('documents_manager'))
@app.route("/view_document/<doc_id>")
def view_document(doc_id):
    """Register a new route for the ``view_document`` page of the app."""
    document: Document = db_utils.get_document(dbConnection, doc_id)

    if not document:
        return "Document not found", 404

    return render_template("view_document.html", document=document)


@app.route('/flag/<int:doc_id>', methods=['POST'])
def flag_document(doc_id):
    # Mock flagging - in production, save to database
    flash('Document flagged for review', 'success')
    return redirect(url_for('document_detail', doc_id=doc_id))


if __name__ == '__main__':
    app.run(debug=True, port=5000)
