import { DocumentCard } from "./DocumentCard";
import { Button } from "./ui/button";
import { Download, Home, Search } from "lucide-react";

interface ViewHistoryProps {
  onHomeClick: () => void;
}

export function ViewHistory({ onHomeClick }: ViewHistoryProps) {
  // Mock previous searches
  const previousSearches = [
    { id: 1, query: "Sunset Boulevard", date: "Nov 15, 2025" },
    { id: 2, query: "Charlie Chaplin", date: "Nov 14, 2025" },
    { id: 3, query: "1927 films", date: "Nov 12, 2025" },
    { id: 4, query: "film noir", date: "Nov 10, 2025" },
    { id: 5, query: "Gone with the Wind", date: "Nov 8, 2025" }
  ];

  // Mock history data - documents the user has viewed
  const historyDocuments = [
    {
      id: 1,
      title: "Sunset Boulevard",
      description: "Copyright registration documents for the classic film noir about a screenwriter and a faded silent film star.",
      year: "1950",
      documentType: "Copyright Registration",
      viewedDate: "Nov 15, 2025"
    },
    {
      id: 2,
      title: "City Lights",
      description: "Charlie Chaplin's romantic comedy-drama about a tramp who falls in love with a blind flower girl.",
      year: "1931",
      documentType: "Copyright Registration",
      viewedDate: "Nov 14, 2025"
    },
    {
      id: 3,
      title: "The Jazz Singer",
      description: "Historic copyright filing for the first feature-length motion picture with synchronized dialogue sequences.",
      year: "1927",
      documentType: "Copyright Registration",
      viewedDate: "Nov 12, 2025"
    }
  ];

  const handleDownloadHistory = () => {
    // Create CSV content
    const csvContent = [
      "Title,Year,Document Type,Description,Viewed Date",
      ...historyDocuments.map(doc => 
        `"${doc.title}","${doc.year}","${doc.documentType}","${doc.description}","${doc.viewedDate}"`
      )
    ].join("\n");

    // Create blob and download
    const blob = new Blob([csvContent], { type: "text/csv" });
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = "viewing-history.csv";
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    window.URL.revokeObjectURL(url);
  };

  return (
    <div className="flex">
      {/* Left Sidebar - Previous Searches */}
      <aside className="w-64 p-6 border-r-2 border-[#E0E0E0] min-h-screen">
        <h3 className="text-[#2C2C2C] mb-4">Previous Searches</h3>
        
        <div className="space-y-3">
          {previousSearches.map((search) => (
            <button
              key={search.id}
              className="w-full text-left p-3 bg-white border-2 border-[#E0E0E0] rounded hover:border-[#8B0000] transition-colors group"
            >
              <div className="flex items-start gap-2">
                <Search className="w-4 h-4 text-[#2B6CB0] mt-0.5 flex-shrink-0" />
                <div className="flex-1 min-w-0">
                  <p className="text-[#2C2C2C] truncate group-hover:text-[#8B0000] transition-colors">
                    {search.query}
                  </p>
                  <p className="text-[#666666] mt-1">
                    {search.date}
                  </p>
                </div>
              </div>
            </button>
          ))}
        </div>

        <Button className="w-full mt-6 bg-white hover:bg-[#F5F5F0] text-[#2C2C2C] border-2 border-[#E0E0E0] hover:border-[#8B0000] transition-colors">
          Clear Search History
        </Button>
      </aside>

      {/* Main Content - Viewing History */}
      <div className="flex-1 p-6">
        <div className="mb-6 flex items-center justify-between">
          <div>
            <h2 className="text-[#2C2C2C]">Your Viewing History</h2>
            <p className="text-[#666666] mt-1">
              {historyDocuments.length} documents viewed
            </p>
          </div>
          <div className="flex gap-3">
            <Button
              onClick={onHomeClick}
              className="bg-white hover:bg-[#F5F5F0] text-[#2C2C2C] border-2 border-[#E0E0E0] hover:border-[#8B0000] transition-colors"
            >
              <Home className="w-4 h-4 mr-2" />
              Home
            </Button>
            <Button
              onClick={handleDownloadHistory}
              className="bg-[#2C2C2C] hover:bg-[#8B0000] text-white transition-colors"
            >
              <Download className="w-4 h-4 mr-2" />
              Download History
            </Button>
          </div>
        </div>

        <div className="space-y-4">
          {historyDocuments.map((doc) => (
            <div key={doc.id} className="relative">
              <DocumentCard
                title={doc.title}
                description={doc.description}
                year={doc.year}
                documentType={doc.documentType}
              />
              <div className="absolute top-4 right-4 text-[#666666]">
                Viewed: {doc.viewedDate}
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}