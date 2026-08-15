import Link from "next/link";
import { SCENARIOS } from "@/lib/scenarios";
import Navbar from "@/components/Navbar";

export default function HomePage() {
  // Helper function to return tailor-made Tailwind styles for each difficulty level
  const getLevelStyles = (level: string) => {
    switch (level.toLowerCase()) {
      case "beginner":
        return "text-emerald-700 dark:text-emerald-300 bg-emerald-50 dark:bg-emerald-950/40 border-emerald-200 dark:border-emerald-800/60";
      case "intermediate":
        return "text-amber-700 dark:text-amber-300 bg-amber-50 dark:bg-amber-950/40 border-amber-200 dark:border-amber-800/60";
      case "advanced":
        return "text-rose-700 dark:text-rose-300 bg-rose-50 dark:bg-rose-950/40 border-rose-200 dark:border-rose-800/60";
      default:
        return "text-ink-soft border-line bg-paper-dim/40";
    }
  };

  return (
    <>
      <Navbar />
      
      <main className="flex-1 w-full pt-2 bg-paper text-ink transition-colors duration-200">
        <div className="max-w-[980px] min-h-full mx-auto px-4">
          <div className="pt-3 pb-1">
            <h1 className="font-display text-[32px] text-ai-indigo-deep mb-1 transition-colors">
              Pick a scenario
            </h1>
            <p className="text-ink-soft text-base leading-[1.55] transition-colors">
              Choose a situation to practice. Your AI roleplay partner stays in character for the whole conversation.
            </p>
          </div>

          <div className="grid grid-cols-[repeat(auto-fill,minmax(260px,1fr))] gap-4 pt-7 pb-6">
            {SCENARIOS.map((s) => (
              <Link
                key={s.id}
                href={`/practice/${s.id}`}
                className="block no-underline text-inherit bg-white dark:bg-paper-dim border border-line rounded-card px-5 pt-5 pb-[18px] transition-all duration-200 ease-out hover:border-ai-indigo hover:bg-paper-dim/20 hover:-translate-y-1 hover:shadow-xl hover:shadow-ai-indigo-deep/5 dark:hover:shadow-black/40"
              >
                {/* CHANGED: Replaced the static hanko-red code block with our dynamic style injector */}
                <span className={`inline-block text-[11px] font-bold tracking-[0.08em] uppercase border rounded-full px-2.5 py-0.5 mb-3 transition-colors ${getLevelStyles(s.level)}`}>
                  {s.level}
                </span>
                
                <p className="font-display text-[15px] text-ink-soft mb-0.5 transition-colors">
                  {s.titleJa}
                </p>
                <h2 className="text-lg font-semibold mb-2 text-ai-indigo-deep transition-colors">
                  {s.title}
                </h2>
                <p className="text-sm leading-relaxed text-ink-soft transition-colors">
                  {s.description}
                </p>
              </Link>
            ))}
          </div>
        </div>
      </main>
    </>
  );
}
