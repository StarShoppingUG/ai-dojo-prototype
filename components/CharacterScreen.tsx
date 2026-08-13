"use client";

import Link from "next/link";
import type { Scenario } from "@/lib/scenarios";
import CharacterCard from "@/components/CharacterCard";

export default function CharactersScreen({ scenario }: { scenario: Scenario }) {
  return (
    <>
      <div className="flex items-start justify-between gap-4 pt-5 pb-5 flex-wrap">
        <div>
          <Link
            href="/"
            className="inline-block text-[15px] text-ink-soft no-underline mb-2.5 hover:text-ai-indigo transition-colors"
          >
            ← Choose a different scenario
          </Link>
          <p className="font-display text-base text-ink-soft mb-0.5 transition-colors">
            {scenario.titleJa}
          </p>
          <h1 className="text-2xl font-bold text-ai-indigo-deep m-0 transition-colors">
            {scenario.title}
          </h1>
        </div>
      </div>

      <div className="grid grid-cols-[repeat(auto-fill,minmax(240px,1fr))] gap-4 pt-2 pb-16">
        {/* 
          CRITICAL STEP: Changed (c) to (c, index) 
          This grabs the item's loop position (0, 1, 2) dynamically.
        */}
{scenario.characters.map((c, index) => (
  <CharacterCard
    key={c.avatarId}
    scenarioId={scenario.id}
    avatarId={c.avatarId}
    fallbackLabel={c.fallbackLabel}
    cardIndex={index} // Passed the raw numeric index variable here
  />
))}
      </div>
    </>
  );
}
