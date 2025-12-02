import { useState } from "react";
import { Button } from "./ui/button";
import { Input } from "./ui/input";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "./ui/dialog";
import { AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent, AlertDialogDescription, AlertDialogFooter, AlertDialogHeader, AlertDialogTitle } from "./ui/alert-dialog";
import { Upload, Trash2, FileText, Search } from "lucide-react";
import { Checkbox } from "./ui/checkbox";
import { Label } from "./ui/label";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "./ui/tabs";

interface Document {
  id: number;
  title: string;
  year: string;
  documentType: string;
  studio: string;
}

interface DocumentsManagerProps {
  onHomeClick: () => void;
}

export function DocumentsManager({ onHomeClick }: DocumentsManagerProps) {
  const [isAddDialogOpen, setIsAddDialogOpen] = useState(false);
  const [isRemoveDialogOpen, setIsRemoveDialogOpen] = useState(false);
  const [selectedDocuments, setSelectedDocuments] = useState<number[]>([]);
  const [searchQuery, setSearchQuery] = useState("");
  const [zipFile, setZipFile] = useState<File | null>(null);
  const [documentFile, setDocumentFile] = useState<File | null>(null);
  const [metadataFile, setMetadataFile] = useState<File | null>(null);
  const [transcriptFile, setTranscriptFile] = useState<File | null>(null);

  // Mock documents in database
  const [documents, setDocuments] = useState<Document[]>([
    {
      id: 1,
      title: "Sunset Boulevard",
      year: "1950",
      documentType: "Copyright Registration",
      studio: "Paramount Pictures"
    },
    {
      id: 2,
      title: "The Jazz Singer",
      year: "1927",
      documentType: "Copyright Registration",
      studio: "Warner Bros."
    },
    {
      id: 3,
      title: "Metropolis",
      year: "1927",
      documentType: "Copyright Registration",
      studio: "UFA (Universum Film AG)"
    },
    {
      id: 4,
      title: "City Lights",
      year: "1931",
      documentType: "Copyright Registration",
      studio: "United Artists"
    },
    {
      id: 5,
      title: "King Kong",
      year: "1933",
      documentType: "Copyright Registration",
      studio: "RKO Radio Pictures"
    },
    {
      id: 6,
      title: "Gone with the Wind",
      year: "1939",
      documentType: "Copyright Registration",
      studio: "Metro-Goldwyn-Mayer"
    }
  ]);

  const filteredDocuments = documents.filter(doc =>
    doc.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
    doc.year.includes(searchQuery) ||
    doc.studio.toLowerCase().includes(searchQuery.toLowerCase())
  );

  const handleSelectDocument = (id: number) => {
    setSelectedDocuments(prev =>
      prev.includes(id)
        ? prev.filter(docId => docId !== id)
        : [...prev, id]
    );
  };

  const handleSelectAll = () => {
    if (selectedDocuments.length === filteredDocuments.length) {
      setSelectedDocuments([]);
    } else {
      setSelectedDocuments(filteredDocuments.map(doc => doc.id));
    }
  };

  const handleRemoveDocuments = () => {
    setDocuments(prev => prev.filter(doc => !selectedDocuments.includes(doc.id)));
    setSelectedDocuments([]);
    setIsRemoveDialogOpen(false);
  };

  const handleAddDocuments = () => {
    // Here you would handle the actual file upload logic
    console.log("ZIP file:", zipFile);
    console.log("Document file:", documentFile);
    console.log("Metadata file:", metadataFile);
    console.log("Transcript file:", transcriptFile);
    
    // Reset form
    setZipFile(null);
    setDocumentFile(null);
    setMetadataFile(null);
    setTranscriptFile(null);
    setIsAddDialogOpen(false);
  };

  return (
    <div className="min-h-screen p-6">
      <div className="mb-6">
        <Button
          onClick={onHomeClick}
          variant="outline"
          className="mb-4 border-2 border-[#8B0000] text-[#8B0000] hover:bg-[#8B0000] hover:text-white"
        >
          ← Back to Search
        </Button>
        <div className="flex items-center justify-between">
          <div>
            <h2 className="text-[#2C2C2C]">Documents Manager</h2>
            <p className="text-[#666666] mt-1">
              Manage copyright documents in the archive
            </p>
          </div>
          <Button
            onClick={() => setIsAddDialogOpen(true)}
            className="bg-[#2B6CB0] hover:bg-[#1E5A8E] text-white flex items-center gap-2"
          >
            <Upload className="w-4 h-4" />
            Add Document(s)
          </Button>
        </div>
      </div>

      {/* Search Interface */}
      <div className="bg-white border-2 border-[#E0E0E0] rounded-lg p-6 mb-6">
        <div className="flex items-center gap-4 mb-4">
          <div className="flex-1 relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-[#666666]" />
            <Input
              type="text"
              placeholder="Search documents by title, year, or studio..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="pl-10 bg-white border-2 border-[#E0E0E0] focus:border-[#8B0000] focus:ring-[#8B0000]"
            />
          </div>
        </div>
        <p className="text-[#666666]">
          {filteredDocuments.length} document{filteredDocuments.length !== 1 ? 's' : ''} found
        </p>
      </div>

      {/* Documents List */}
      <div className="bg-white border-2 border-[#E0E0E0] rounded-lg overflow-hidden">
        <div className="p-4 bg-[#F5F5F0] border-b-2 border-[#E0E0E0] flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Checkbox
              checked={selectedDocuments.length === filteredDocuments.length && filteredDocuments.length > 0}
              onCheckedChange={handleSelectAll}
              className="border-2 border-[#2C2C2C]"
            />
            <span className="text-[#2C2C2C]">
              {selectedDocuments.length > 0 
                ? `${selectedDocuments.length} selected` 
                : "Select all"}
            </span>
          </div>
          {selectedDocuments.length > 0 && (
            <Button
              onClick={() => setIsRemoveDialogOpen(true)}
              variant="destructive"
              className="bg-[#8B0000] hover:bg-[#A52A2A] flex items-center gap-2"
            >
              <Trash2 className="w-4 h-4" />
              Remove Selected
            </Button>
          )}
        </div>

        <div className="divide-y-2 divide-[#E0E0E0]">
          {filteredDocuments.map((doc) => (
            <div
              key={doc.id}
              className={`p-4 flex items-center gap-4 hover:bg-[#FFF8F0] transition-colors ${
                selectedDocuments.includes(doc.id) ? 'bg-[#FFF8F0]' : ''
              }`}
            >
              <Checkbox
                checked={selectedDocuments.includes(doc.id)}
                onCheckedChange={() => handleSelectDocument(doc.id)}
                className="border-2 border-[#2C2C2C]"
              />
              <div className="flex-shrink-0">
                <div className="w-16 h-20 bg-[#F5F5F0] border border-[#CCCCCC] rounded flex items-center justify-center">
                  <FileText className="w-8 h-8 text-[#666666]" />
                </div>
              </div>
              <div className="flex-1">
                <h3 className="text-[#800080] mb-1">{doc.title}</h3>
                <div className="flex gap-3 text-[#666666]">
                  <span>{doc.year}</span>
                  <span>•</span>
                  <span>{doc.documentType}</span>
                  <span>•</span>
                  <span>{doc.studio}</span>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Add Documents Dialog */}
      <Dialog open={isAddDialogOpen} onOpenChange={setIsAddDialogOpen}>
        <DialogContent className="max-w-2xl bg-[#F5F5F0] border-2 border-[#8B0000]">
          <DialogHeader>
            <DialogTitle className="text-[#2C2C2C]">Add Document(s)</DialogTitle>
          </DialogHeader>
          
          <Tabs defaultValue="zip" className="w-full">
            <TabsList className="grid w-full grid-cols-2 bg-white">
              <TabsTrigger value="zip" className="data-[state=active]:bg-[#8B0000] data-[state=active]:text-white">
                Upload ZIP
              </TabsTrigger>
              <TabsTrigger value="individual" className="data-[state=active]:bg-[#8B0000] data-[state=active]:text-white">
                Individual Files
              </TabsTrigger>
            </TabsList>

            <TabsContent value="zip" className="space-y-4 mt-4">
              <div>
                <Label htmlFor="zip-upload" className="text-[#2C2C2C] mb-2 block">
                  ZIP File (containing documents, metadata, and transcripts)
                </Label>
                <div className="border-2 border-dashed border-[#2B6CB0] rounded-lg p-8 text-center bg-white hover:border-[#8B0000] transition-colors">
                  <Upload className="w-12 h-12 text-[#666666] mx-auto mb-3" />
                  <Input
                    id="zip-upload"
                    type="file"
                    accept=".zip"
                    onChange={(e) => setZipFile(e.target.files?.[0] || null)}
                    className="hidden"
                  />
                  <label htmlFor="zip-upload" className="cursor-pointer">
                    <p className="text-[#2C2C2C] mb-1">
                      {zipFile ? zipFile.name : "Click to upload ZIP file"}
                    </p>
                    <p className="text-[#666666]">
                      or drag and drop
                    </p>
                  </label>
                </div>
              </div>
            </TabsContent>

            <TabsContent value="individual" className="space-y-4 mt-4">
              <div>
                <Label htmlFor="document-upload" className="text-[#2C2C2C] mb-2 block">
                  Document (PDF)
                </Label>
                <div className="border-2 border-[#E0E0E0] rounded-lg p-4 bg-white">
                  <Input
                    id="document-upload"
                    type="file"
                    accept=".pdf"
                    onChange={(e) => setDocumentFile(e.target.files?.[0] || null)}
                    className="border-2 border-[#E0E0E0] focus:border-[#8B0000]"
                  />
                  {documentFile && (
                    <p className="text-[#666666] mt-2">Selected: {documentFile.name}</p>
                  )}
                </div>
              </div>

              <div>
                <Label htmlFor="metadata-upload" className="text-[#2C2C2C] mb-2 block">
                  Metadata (JSON or XML)
                </Label>
                <div className="border-2 border-[#E0E0E0] rounded-lg p-4 bg-white">
                  <Input
                    id="metadata-upload"
                    type="file"
                    accept=".json,.xml"
                    onChange={(e) => setMetadataFile(e.target.files?.[0] || null)}
                    className="border-2 border-[#E0E0E0] focus:border-[#8B0000]"
                  />
                  {metadataFile && (
                    <p className="text-[#666666] mt-2">Selected: {metadataFile.name}</p>
                  )}
                </div>
              </div>

              <div>
                <Label htmlFor="transcript-upload" className="text-[#2C2C2C] mb-2 block">
                  Transcript (TXT)
                </Label>
                <div className="border-2 border-[#E0E0E0] rounded-lg p-4 bg-white">
                  <Input
                    id="transcript-upload"
                    type="file"
                    accept=".txt"
                    onChange={(e) => setTranscriptFile(e.target.files?.[0] || null)}
                    className="border-2 border-[#E0E0E0] focus:border-[#8B0000]"
                  />
                  {transcriptFile && (
                    <p className="text-[#666666] mt-2">Selected: {transcriptFile.name}</p>
                  )}
                </div>
              </div>
            </TabsContent>
          </Tabs>

          <DialogFooter className="gap-2">
            <Button
              variant="outline"
              onClick={() => setIsAddDialogOpen(false)}
              className="border-2 border-[#2C2C2C] text-[#2C2C2C] hover:bg-[#2C2C2C] hover:text-white"
            >
              Cancel
            </Button>
            <Button
              onClick={handleAddDocuments}
              className="bg-[#2B6CB0] hover:bg-[#1E5A8E] text-white"
            >
              Upload Documents
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Remove Confirmation Dialog */}
      <AlertDialog open={isRemoveDialogOpen} onOpenChange={setIsRemoveDialogOpen}>
        <AlertDialogContent className="bg-[#F5F5F0] border-2 border-[#8B0000]">
          <AlertDialogHeader>
            <AlertDialogTitle className="text-[#2C2C2C]">
              Confirm Removal
            </AlertDialogTitle>
            <AlertDialogDescription className="text-[#666666]">
              Are you sure you want to remove {selectedDocuments.length} document
              {selectedDocuments.length !== 1 ? 's' : ''} from the database? This action cannot be undone.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel className="border-2 border-[#2C2C2C] text-[#2C2C2C] hover:bg-[#2C2C2C] hover:text-white">
              Cancel
            </AlertDialogCancel>
            <AlertDialogAction
              onClick={handleRemoveDocuments}
              className="bg-[#8B0000] hover:bg-[#A52A2A] text-white"
            >
              Remove Documents
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
