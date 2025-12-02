export function Header({ 
  onLoginClick, 
  onViewHistoryClick,
  onFlaggedDocumentsClick,
  onDocumentsManagerClick
}: { 
  onLoginClick: () => void;
  onViewHistoryClick: () => void;
  onFlaggedDocumentsClick: () => void;
  onDocumentsManagerClick: () => void;
}) {
  return (
    <header className="bg-[#8B0000] text-white px-6 py-4">
      <div className="max-w-7xl mx-auto flex items-center justify-between">
        <div>
          <h1 className="text-white">Recovering Early Hollywood</h1>
        </div>
        <nav className="flex items-center gap-6">
          <button 
            onClick={onViewHistoryClick}
            className="text-white hover:opacity-80 transition-opacity"
          >
            View History
          </button>
          <button 
            onClick={onFlaggedDocumentsClick}
            className="text-white hover:opacity-80 transition-opacity"
          >
            Flagged Documents
          </button>
          <button 
            onClick={onDocumentsManagerClick}
            className="text-white hover:opacity-80 transition-opacity"
          >
            Documents Manager
          </button>
          <button
            onClick={onLoginClick}
            className="text-white hover:opacity-80 transition-opacity"
          >
            Login
          </button>
        </nav>
      </div>
    </header>
  );
}