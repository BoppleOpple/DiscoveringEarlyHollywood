import { ImageWithFallback } from "./figma/ImageWithFallback";

interface DocumentCardProps {
  title: string;
  description: string;
  year: string;
  documentType: string;
  onClick?: () => void;
}

export function DocumentCard({ title, description, year, documentType, onClick }: DocumentCardProps) {
  return (
    <button
      onClick={onClick}
      className="w-full bg-white border-2 border-[#E0E0E0] rounded-lg p-4 hover:border-[#8B0000] transition-colors text-left"
    >
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
          <h3 className="text-[#800080] mb-2">{title}</h3>
          <p className="text-[#666666] mb-3">{description}</p>
          <div className="flex gap-4">
            <span className="text-[#2B6CB0]">{year}</span>
            <span className="text-[#666666]">•</span>
            <span className="text-[#666666]">{documentType}</span>
          </div>
        </div>
      </div>
    </button>
  );
}