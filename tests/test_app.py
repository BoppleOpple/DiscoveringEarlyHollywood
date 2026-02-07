# Flask routes and allowed_file utility

from backend.app import allowed_file


class TestAllowedFile:
    def test_allows_png(self):
        assert allowed_file("image.png") is True

    def test_allows_jpg(self):
        assert allowed_file("photo.jpg") is True

    def test_allows_jpeg(self):
        assert allowed_file("photo.jpeg") is True

    def test_allows_pdf(self):
        assert allowed_file("document.pdf") is True

    def test_rejects_txt(self):
        assert allowed_file("readme.txt") is False

    def test_rejects_no_extension(self):
        assert allowed_file("noextension") is False

    def test_rejects_empty_filename(self):
        assert allowed_file("") is False

    def test_extension_case_insensitive(self):
        assert allowed_file("image.PNG") is True
        assert allowed_file("image.JPG") is True


class TestFlaskRoutes:
    def test_home_returns_200(self, client):
        response = client.get("/")
        assert response.status_code == 200

    def test_upload_page_returns_200(self, client):
        response = client.get("/upload")
        assert response.status_code == 200

    def test_history_returns_200(self, client):
        response = client.get("/history")
        assert response.status_code == 200

    def test_upload_pdf_returns_200(self, client):
        response = client.get("/upload_pdf")
        assert response.status_code == 200
