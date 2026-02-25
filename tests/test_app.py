from unittest.mock import patch, MagicMock


def test_download_document_serves_pdf_when_exists(client, tmp_path, monkeypatch):
    from backend import app as backend_app

    # Point DOCUMENT_DIR at a temp folder and create fake PDF
    doc_id = "s0000l12345"
    doc_dir = tmp_path / doc_id
    doc_dir.mkdir(parents=True)
    pdf_path = doc_dir / f"{doc_id}.pdf"
    pdf_path.write_bytes(b"%PDF-FAKE")  # content doesn't matter

    monkeypatch.setattr(backend_app, "DOCUMENT_DIR", tmp_path)

    resp = client.get(f"/document/{doc_id}/download")
    assert resp.status_code == 200
    assert resp.headers["Content-Type"].startswith("application/pdf")
    assert f"{doc_id}.pdf" in resp.headers["Content-Disposition"]


def test_download_document_falls_back_to_txt_when_no_pdf(client, monkeypatch):
    # Ensure DOCUMENT_DIR is None or has no PDF, and mock DB document
    monkeypatch.setattr("backend.app.DOCUMENT_DIR", None, raising=False)

    mock_doc = MagicMock()
    mock_doc.transcripts = [(1, "Page 1 text"), (2, "Page 2 text")]
    with patch("backend.app.db_utils.get_document", return_value=mock_doc):
        resp = client.get("/document/s0000l12345/download")

    assert resp.status_code == 200
    assert resp.headers["Content-Type"].startswith("text/plain")
    assert "s0000l12345.txt" in resp.headers["Content-Disposition"]
    body = resp.data.decode("utf-8")
    assert "Page 1 text" in body and "Page 2 text" in body


def test_download_document_invalid_or_missing_transcripts_redirects(client):
    # invalid ID
    r1 = client.get("/document/invalid/download")
    assert r1.status_code in (301, 302)

    # valid ID but no document / transcripts
    with patch("backend.app.db_utils.get_document", return_value=None):
        r2 = client.get("/document/s0000l12345/download")
    assert r2.status_code in (301, 302)
