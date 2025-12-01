import { Button } from "./ui/button";
import { ArrowLeft } from "lucide-react";

interface DocumentDetailProps {
  document: {
    id: number;
    title: string;
    description: string;
    year: string;
    documentType: string;
    fullDescription: string;
    studio: string;
    genre: string;
    director: string;
    actors: string[];
    runtime: string;
    language: string;
  };
  onBack: () => void;
}

export function DocumentDetail({
  document,
  onBack,
}: DocumentDetailProps) {
  return (
    <div className="flex-1 p-6">
      <Button
        onClick={onBack}
        className="mb-6 bg-white hover:bg-[#F5F5F0] text-[#2C2C2C] border-2 border-[#E0E0E0] hover:border-[#8B0000] transition-colors"
      >
        <ArrowLeft className="w-4 h-4 mr-2" />
        Back to Results
      </Button>

      <div className="bg-white border-2 border-[#E0E0E0] rounded-lg p-8">
        <div className="flex gap-8">
          {/* PDF Image - Top Left */}
          <div className="flex-shrink-0">
            <div className="w-64 h-80 bg-[#F5F5F0] border-2 border-[#CCCCCC] rounded-lg flex items-center justify-center">
              <div className="text-center">
                <svg
                  className="w-24 h-24 text-[#666666] mx-auto mb-4"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth={1.5}
                    d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z"
                  />
                </svg>
                <p className="text-[#666666]">
                  Copyright Document
                </p>
                <p className="text-[#666666] mt-1">
                  {document.year}
                </p>
              </div>
            </div>
          </div>

          {/* Content - Right Side */}
          <div className="flex-1">
            <div className="float-right border-[#E0E0E0]">
              <Button className="bg-[#2C2C2C] hover:bg-[#8B0000] text-white transition-colors">
                Flag Document
              </Button>
            </div>
            <h2 className="text-[#800080] mb-4">
              {document.title}
            </h2>

            <div className="mb-6">
              <h3 className="text-[#2C2C2C] mb-2">
                Description
              </h3>
              <p className="text-[#666666] leading-relaxed">
                {document.fullDescription}
              </p>
            </div>

            <div className="grid grid-cols-2 gap-6">
              <div>
                <h4 className="text-[#2C2C2C] mb-3">
                  Film Details
                </h4>
                <div className="space-y-2">
                  <div className="flex">
                    <span className="text-[#666666] w-24">
                      Year:
                    </span>
                    <span className="text-[#2C2C2C]">
                      {document.year}
                    </span>
                  </div>
                  <div className="flex">
                    <span className="text-[#666666] w-24">
                      Studio:
                    </span>
                    <span className="text-[#2C2C2C]">
                      {document.studio}
                    </span>
                  </div>
                  <div className="flex">
                    <span className="text-[#666666] w-24">
                      Genre:
                    </span>
                    <span className="text-[#2C2C2C]">
                      {document.genre}
                    </span>
                  </div>
                  <div className="flex">
                    <span className="text-[#666666] w-24">
                      Director:
                    </span>
                    <span className="text-[#2C2C2C]">
                      {document.director}
                    </span>
                  </div>
                  <div className="flex">
                    <span className="text-[#666666] w-24">
                      Runtime:
                    </span>
                    <span className="text-[#2C2C2C]">
                      {document.runtime}
                    </span>
                  </div>
                  <div className="flex">
                    <span className="text-[#666666] w-24">
                      Language:
                    </span>
                    <span className="text-[#2C2C2C]">
                      {document.language}
                    </span>
                  </div>
                </div>
              </div>

              <div>
                <h4 className="text-[#2C2C2C] mb-3">Cast</h4>
                <div className="space-y-1">
                  {document.actors.map((actor, index) => (
                    <p key={index} className="text-[#2C2C2C]">
                      {actor}
                    </p>
                  ))}
                </div>
              </div>

              <div className="col-span-2 mt-4">
                <h4 className="text-[#2C2C2C] mb-3">
                  Document Information
                </h4>
                <div className="flex gap-8">
                  <div className="flex">
                    <span className="text-[#666666] w-32">
                      Document Type:
                    </span>
                    <span className="text-[#2C2C2C]">
                      {document.documentType}
                    </span>
                  </div>
                  <div className="flex">
                    <span className="text-[#666666] w-32">
                      Registration Date:
                    </span>
                    <span className="text-[#2C2C2C]">
                      {document.year}
                    </span>
                  </div>
                </div>
              </div>
            </div>

            <div className="mt-8 pt-6 border-t-2 border-[#E0E0E0]">
              <Button className="bg-[#2C2C2C] hover:bg-[#8B0000] text-white transition-colors">
                Download Document
              </Button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}