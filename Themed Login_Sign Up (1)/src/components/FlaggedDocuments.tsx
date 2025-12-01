import { useState } from "react";
import { Button } from "./ui/button";
import { Flag, ChevronDown, ChevronUp } from "lucide-react";

interface FlagComment {
  id: number;
  user: string;
  reason: string;
  date: string;
}

interface FlaggedDocument {
  id: number;
  title: string;
  description: string;
  year: string;
  documentType: string;
  flags: FlagComment[];
}

interface FlaggedDocumentsProps {
  onHomeClick: () => void;
  onDocumentClick: (id: number) => void;
}

export function FlaggedDocuments({ onHomeClick, onDocumentClick }: FlaggedDocumentsProps) {
  const [expandedFlags, setExpandedFlags] = useState<Record<number, boolean>>({});

  // Mock flagged documents data
  const flaggedDocuments: FlaggedDocument[] = [
    {
      id: 1,
      title: "Sunset Boulevard",
      description: "Copyright registration documents for the classic film noir about a screenwriter and a faded silent film star.",
      year: "1950",
      documentType: "Copyright Registration",
      flags: [
        {
          id: 1,
          user: "Dr. Sarah Mitchell",
          reason: "Document appears to have incorrect filing date. Should be cross-referenced with studio records.",
          date: "Nov 15, 2025"
        },
        {
          id: 2,
          user: "James Rodriguez",
          reason: "Missing signature on page 3 of the copyright registration form.",
          date: "Nov 12, 2025"
        },
        {
          id: 3,
          user: "Emily Chen",
          reason: "Potential discrepancy in the listed production company name.",
          date: "Nov 10, 2025"
        }
      ]
    },
    {
      id: 3,
      title: "Metropolis",
      description: "Copyright documentation for Fritz Lang's influential German expressionist science-fiction film.",
      year: "1927",
      documentType: "Copyright Registration",
      flags: [
        {
          id: 4,
          user: "Prof. Heinrich Weber",
          reason: "Translation of German text may be inaccurate. Requires verification by native speaker.",
          date: "Nov 14, 2025"
        },
        {
          id: 5,
          user: "Anna Foster",
          reason: "Document quality is poor - some text illegible. May need restoration or alternative source.",
          date: "Nov 8, 2025"
        }
      ]
    },
    {
      id: 6,
      title: "Gone with the Wind",
      description: "Epic historical romance film set during the American Civil War and Reconstruction era.",
      year: "1939",
      documentType: "Copyright Registration",
      flags: [
        {
          id: 6,
          user: "Michael Thompson",
          reason: "Multiple versions of this document exist in archive. Need to verify which is the original filing.",
          date: "Nov 13, 2025"
        }
      ]
    }
  ];

  const toggleFlags = (docId: number) => {
    setExpandedFlags(prev => ({
      ...prev,
      [docId]: !prev[docId]
    }));
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
        <h2 className="text-[#2C2C2C]">Flagged Documents</h2>
        <p className="text-[#666666] mt-1">
          {flaggedDocuments.length} documents flagged for review
        </p>
      </div>

      <div className="space-y-4">
        {flaggedDocuments.map((doc) => (
          <div
            key={doc.id}
            className="bg-white border-2 border-[#E0E0E0] rounded-lg overflow-hidden"
          >
            <div className="p-4">
              <div className="flex gap-4">
                <div className="flex-shrink-0">
                  <div className="w-24 h-32 bg-[#F5F5F0] border border-[#CCCCCC] rounded flex items-center justify-center">
                    <svg
                      className="w-12 h-12 text-[#666666]"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        strokeWidth={2}
                        d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z"
                      />
                    </svg>
                  </div>
                </div>
                <div className="flex-1">
                  <div className="flex items-start justify-between">
                    <button
                      onClick={() => onDocumentClick(doc.id)}
                      className="text-left flex-1 group"
                    >
                      <h3 className="text-[#800080] mb-2 group-hover:underline">
                        {doc.title}
                      </h3>
                      <p className="text-[#666666] mb-3">{doc.description}</p>
                      <div className="flex gap-4">
                        <span className="text-[#2B6CB0]">{doc.year}</span>
                        <span className="text-[#666666]">•</span>
                        <span className="text-[#666666]">{doc.documentType}</span>
                      </div>
                    </button>
                    <button
                      onClick={() => toggleFlags(doc.id)}
                      className="ml-4 flex items-center gap-2 px-4 py-2 bg-[#8B0000] text-white rounded hover:bg-[#A52A2A] transition-colors"
                    >
                      <Flag className="w-4 h-4" />
                      <span>{doc.flags.length} {doc.flags.length === 1 ? 'Flag' : 'Flags'}</span>
                      {expandedFlags[doc.id] ? (
                        <ChevronUp className="w-4 h-4" />
                      ) : (
                        <ChevronDown className="w-4 h-4" />
                      )}
                    </button>
                  </div>
                </div>
              </div>
            </div>

            {/* Flag Comments Dropdown */}
            {expandedFlags[doc.id] && (
              <div className="border-t-2 border-[#E0E0E0] bg-[#FFF8F0] p-4">
                <h4 className="text-[#2C2C2C] mb-3">
                  Review Comments
                </h4>
                <div className="space-y-3">
                  {doc.flags.map((flag) => (
                    <div
                      key={flag.id}
                      className="bg-white border border-[#E0E0E0] rounded-lg p-3"
                    >
                      <div className="flex items-start justify-between mb-2">
                        <div className="flex items-center gap-2">
                          <div className="w-8 h-8 bg-[#8B0000] rounded-full flex items-center justify-center text-white">
                            {flag.user.split(' ').map(n => n[0]).join('')}
                          </div>
                          <div>
                            <p className="text-[#2C2C2C]">{flag.user}</p>
                            <p className="text-[#999999]">{flag.date}</p>
                          </div>
                        </div>
                      </div>
                      <p className="text-[#666666] ml-10">
                        {flag.reason}
                      </p>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>
        ))}
      </div>
    </div>
  );
}
