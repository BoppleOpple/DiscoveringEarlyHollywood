import { useState } from "react";
import { Header } from "./components/Header";
import { AuthDialog } from "./components/AuthDialog";
import { DocumentCard } from "./components/DocumentCard";
import { DocumentDetail } from "./components/DocumentDetail";
import { ViewHistory } from "./components/ViewHistory";
import { FlaggedDocuments } from "./components/FlaggedDocuments";
import { DocumentsManager } from "./components/DocumentsManager";
import { Button } from "./components/ui/button";
import { Input } from "./components/ui/input";
import { Slider } from "./components/ui/slider";

export default function App() {
  const [isAuthDialogOpen, setIsAuthDialogOpen] =
    useState(false);
  const [currentPage, setCurrentPage] = useState<
    "home" | "history" | "flagged" | "manager"
  >("home");
  const [selectedDocument, setSelectedDocument] = useState<
    number | null
  >(null);

  // Mock document data with full details
  const documents = [
    {
      id: 1,
      title: "Sunset Boulevard",
      description:
        "Copyright registration documents for the classic film noir about a screenwriter and a faded silent film star.",
      year: "1950",
      documentType: "Copyright Registration",
      fullDescription:
        "Sunset Boulevard is a classic American film noir that tells the story of Joe Gillis, a struggling screenwriter, who becomes entangled with Norma Desmond, a faded silent film star living in the past. The film is a dark and cynical examination of Hollywood's treatment of aging stars and the price of fame. Directed by Billy Wilder, the film received widespread critical acclaim and is considered one of the greatest films ever made. The narrative unfolds through flashback as Joe's dead body is discovered floating in Norma's swimming pool, creating a haunting and unforgettable cinematic experience.",
      studio: "Paramount Pictures",
      genre: "Film Noir / Drama",
      director: "Billy Wilder",
      actors: [
        "Gloria Swanson",
        "William Holden",
        "Erich von Stroheim",
        "Nancy Olson",
      ],
      runtime: "110 minutes",
      language: "English",
    },
    {
      id: 2,
      title: "The Jazz Singer",
      description:
        "Historic copyright filing for the first feature-length motion picture with synchronized dialogue sequences.",
      year: "1927",
      documentType: "Copyright Registration",
      fullDescription:
        "The Jazz Singer revolutionized the film industry as the first feature-length motion picture with synchronized dialogue sequences, effectively marking the end of the silent film era. The film tells the story of Jakie Rabinowitz, a young man torn between his Jewish heritage and his dreams of becoming a jazz singer. When he defies his father, a cantor, to pursue a career in entertainment, he must reconcile his love for modern music with his family's traditional expectations. This groundbreaking film not only introduced sound to cinema but also explored themes of generational conflict, cultural identity, and the American dream.",
      studio: "Warner Bros.",
      genre: "Musical Drama",
      director: "Alan Crosland",
      actors: [
        "Al Jolson",
        "May McAvoy",
        "Warner Oland",
        "Eugenie Besserer",
      ],
      runtime: "88 minutes",
      language: "English",
    },
    {
      id: 3,
      title: "Metropolis",
      description:
        "Copyright documentation for Fritz Lang's influential German expressionist science-fiction film.",
      year: "1927",
      documentType: "Copyright Registration",
      fullDescription:
        "Metropolis is a groundbreaking German expressionist science-fiction film set in a futuristic dystopian city where society is divided between the wealthy industrialists who live in luxury skyscrapers and the oppressed workers who toil in underground factories. The film follows Freder, the son of the city's mastermind, as he falls in love with Maria, a working-class prophet who preaches peace between the classes. With its stunning visual effects, elaborate sets, and powerful social commentary, Metropolis has influenced countless films and remains a masterpiece of early cinema.",
      studio: "UFA (Universum Film AG)",
      genre: "Science Fiction / Drama",
      director: "Fritz Lang",
      actors: [
        "Brigitte Helm",
        "Gustav Fröhlich",
        "Alfred Abel",
        "Rudolf Klein-Rogge",
      ],
      runtime: "153 minutes",
      language: "Silent (German intertitles)",
    },
    {
      id: 4,
      title: "City Lights",
      description:
        "Charlie Chaplin's romantic comedy-drama about a tramp who falls in love with a blind flower girl.",
      year: "1931",
      documentType: "Copyright Registration",
      fullDescription:
        "City Lights is a silent romantic comedy-drama that showcases Charlie Chaplin's genius as a filmmaker and performer. The story follows the Little Tramp as he falls in love with a blind flower girl and befriends a suicidal millionaire. Determined to help the girl regain her sight, the Tramp embarks on a series of misadventures to raise money for her operation. Despite being released after the advent of sound films, Chaplin insisted on making City Lights as a silent film with a synchronized musical score, demonstrating his commitment to the art form that made him famous. The film's blend of comedy and pathos, culminating in one of cinema's most moving endings, cement its place as one of the greatest films ever made.",
      studio: "United Artists",
      genre: "Romance / Comedy",
      director: "Charlie Chaplin",
      actors: [
        "Charlie Chaplin",
        "Virginia Cherrill",
        "Florence Lee",
        "Harry Myers",
      ],
      runtime: "87 minutes",
      language: "Silent with music",
    },
    {
      id: 5,
      title: "King Kong",
      description:
        "Copyright records for the groundbreaking adventure film featuring revolutionary special effects.",
      year: "1933",
      documentType: "Copyright Registration",
      fullDescription:
        "King Kong is a landmark adventure film that revolutionized special effects and set the standard for monster movies. The story follows filmmaker Carl Denham as he leads an expedition to the mysterious Skull Island, where they encounter the giant ape Kong. When Kong becomes infatuated with actress Ann Darrow, Denham captures him and brings him to New York City as a theatrical attraction. The film's climactic sequence atop the Empire State Building has become one of cinema's most iconic moments. Through groundbreaking stop-motion animation and innovative composite photography, King Kong brought to life a creature that captured audiences' imaginations and spawned countless imitators.",
      studio: "RKO Radio Pictures",
      genre: "Adventure / Horror",
      director: "Merian C. Cooper, Ernest B. Schoedsack",
      actors: ["Fay Wray", "Robert Armstrong", "Bruce Cabot"],
      runtime: "100 minutes",
      language: "English",
    },
    {
      id: 6,
      title: "Gone with the Wind",
      description:
        "Epic historical romance film set during the American Civil War and Reconstruction era.",
      year: "1939",
      documentType: "Copyright Registration",
      fullDescription:
        "Gone with the Wind is an epic historical romance that follows the life of Scarlett O'Hara, a strong-willed Southern belle, through the American Civil War and Reconstruction era. Set against the backdrop of the South's transformation, the film chronicles Scarlett's tumultuous relationship with roguish blockade runner Rhett Butler, her obsession with Ashley Wilkes, and her determination to save her family's plantation, Tara. With its sweeping cinematography, elaborate costumes, and memorable performances, Gone with the Wind became one of the highest-grossing films of all time and won eight Academy Awards. The film remains a cultural touchstone, though its romanticized portrayal of the antebellum South has generated significant controversy.",
      studio: "Metro-Goldwyn-Mayer",
      genre: "Historical Romance / Drama",
      director: "Victor Fleming",
      actors: [
        "Vivien Leigh",
        "Clark Gable",
        "Olivia de Havilland",
        "Leslie Howard",
      ],
      runtime: "238 minutes",
      language: "English",
    },
  ];

  return (
    <div className="min-h-screen bg-[#F5F5F0]">
      <Header
        onLoginClick={() => setIsAuthDialogOpen(true)}
        onViewHistoryClick={() => setCurrentPage("history")}
        onFlaggedDocumentsClick={() => setCurrentPage("flagged")}
        onDocumentsManagerClick={() => setCurrentPage("manager")}
      />

      {currentPage === "home" ? (
        selectedDocument !== null ? (
          <div className="max-w-7xl mx-auto">
            <DocumentDetail
              document={
                documents.find(
                  (doc) => doc.id === selectedDocument,
                ) as any
              }
              onBack={() => setSelectedDocument(null)}
            />
          </div>
        ) : (
          <div className="flex max-w-7xl mx-auto">
            {/* Left Sidebar - Search Filters */}
            <aside className="w-64 p-6 border-r-2 border-[#E0E0E0] min-h-screen">
              <h3 className="text-[#2C2C2C] mb-4">
                Search & Filter
              </h3>

              <div className="space-y-6">
                <div>
                  <label className="text-[#2C2C2C] block mb-2">
                    Search
                  </label>
                  <Input
                    type="text"
                    placeholder="search"
                    className="bg-white border-2 border-[#2B6CB0] focus:border-[#8B0000] focus:ring-[#8B0000] rounded-full px-4 w-full"
                  />
                </div>

                <div>
                  <label className="text-[#2C2C2C] block mb-2">
                    Year
                  </label>
                  <div className="px-2 py-4">
                    <Slider
                      defaultValue={[1915, 1926]}
                      min={1915}
                      max={1926}
                      step={1}
                      className="[&_[role=slider]]:bg-[#8B0000] [&_[role=slider]]:border-[#8B0000]"
                    />
                    <div className="flex justify-between mt-2">
                      <span className="text-[#666666]">
                        1915
                      </span>
                      <span className="text-[#666666]">
                        1926
                      </span>
                    </div>
                  </div>
                </div>

                <div>
                  <label className="text-[#2C2C2C] block mb-2">
                    Genre
                  </label>
                  <select className="w-full px-4 py-2 border-2 border-[#E0E0E0] rounded bg-white text-[#2C2C2C] cursor-pointer hover:border-[#8B0000] transition-colors">
                    <option>Action</option>
                    <option>Comedy</option>
                    <option>Drama</option>
                    <option>Horror</option>
                  </select>
                </div>

                <Button className="w-full bg-[#2C2C2C] hover:bg-[#8B0000] text-white transition-colors">
                  Apply Filters
                </Button>
              </div>
            </aside>

            {/* Main Content - Document List */}
            <main className="flex-1 p-6">
              <div className="mb-6">
                <h2 className="text-[#2C2C2C]">
                  Copyright Documents from Early Hollywood
                </h2>
                <p className="text-[#666666] mt-1">
                  {documents.length} documents found
                </p>
              </div>

              <div className="space-y-4">
                {documents.map((doc) => (
                  <DocumentCard
                    key={doc.id}
                    title={doc.title}
                    description={doc.description}
                    year={doc.year}
                    documentType={doc.documentType}
                    onClick={() => setSelectedDocument(doc.id)}
                  />
                ))}
              </div>
            </main>
          </div>
        )
      ) : currentPage === "history" ? (
        <div className="max-w-7xl mx-auto">
          <ViewHistory
            onHomeClick={() => setCurrentPage("home")}
          />
        </div>
      ) : currentPage === "flagged" ? (
        <div className="max-w-7xl mx-auto">
          <FlaggedDocuments
            onHomeClick={() => setCurrentPage("home")}
            onDocumentClick={(id) => {
              setSelectedDocument(id);
              setCurrentPage("home");
            }}
          />
        </div>
      ) : (
        <div className="max-w-7xl mx-auto">
          <DocumentsManager
            onHomeClick={() => setCurrentPage("home")}
          />
        </div>
      )}

      <AuthDialog
        open={isAuthDialogOpen}
        onOpenChange={setIsAuthDialogOpen}
      />
    </div>
  );
}