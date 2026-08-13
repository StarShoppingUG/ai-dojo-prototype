import { notFound } from "next/navigation";
import { getScenario, SCENARIOS } from "@/lib/scenarios";
import CharactersScreen from "@/components/CharacterScreen";
import Navbar from "@/components/Navbar";

export default async function ScenarioCharactersPage({
  params,
}: {
  params: Promise<{ scenarioId: string }>;
}) {
  const { scenarioId } = await params;
  const scenario = getScenario(scenarioId);
  if (!scenario) notFound();

  return (
    <>
      <Navbar />
      
      <main className="flex-1 w-full pt-2 bg-paper text-ink transition-colors duration-200">
        <div className="max-w-[980px] min-h-full mx-auto px-4">
          <CharactersScreen scenario={scenario} />
        </div>
      </main>
    </>
  );
}
