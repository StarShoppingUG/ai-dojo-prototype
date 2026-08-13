import { notFound } from "next/navigation";
import { getScenario, getScenarioCharacter, SCENARIOS } from "@/lib/scenarios";
import AvatarComponents from "@/components/AvatarComponents";

export function generateStaticParams() {
  return SCENARIOS.flatMap((s) =>
    s.characters.map((c) => ({ scenarioId: s.id, characterId: c.avatarId }))
  );
}

export default async function CharacterInteractionPage({
  params,
}: {
  params: Promise<{ scenarioId: string; characterId: string }>;
}) {
  const { scenarioId, characterId } = await params;
  const scenario = getScenario(scenarioId);
  if (!scenario) notFound();

  const character = getScenarioCharacter(scenarioId, characterId);
  if (!character) notFound();

  return <AvatarComponents scenario={scenario} avatarId={character.avatarId} />;
}