export type ScenarioCharacterSlot = {
  // The avatarId this character should map to in the AI Avatar Team's
  // roster (AvatarSources.js). GUESSED, same caveat as the old
  // NEXT_PUBLIC_DOJO_AVATAR_ID default in config.ts — needs confirming
  // against a real `avatar:available-avatars` event payload. If the id
  // doesn't match anything in the live roster, the characters page will
  // simply fail to find/render this slot (see lib/avatarRoster.ts).
  avatarId: string;
  // Fallback label shown on the character card ONLY if the roster event
  // doesn't give us a name for this avatarId. Not sent to the backend.
  fallbackLabel: string;
};

export type Scenario = {
  id: string;
  title: string;
  titleJa: string;
  level: "Beginner" | "Intermediate" | "Advanced";
  description: string;
  backgroundImage: string;
  characters: [
    ScenarioCharacterSlot,
    ScenarioCharacterSlot,
    ScenarioCharacterSlot,
  ];
};

export const SCENARIOS: Scenario[] = [
  {
    id: "restaurant",
    title: "Ordering at a restaurant",
    titleJa: "レストランで注文する",
    level: "Beginner",
    description:
      "Practice greeting staff, asking about the menu, and placing an order at a casual Japanese restaurant.",
    backgroundImage: "/scenarios/restaurant.webp",
    characters: [
      { avatarId: "restaurant_1", fallbackLabel: "Friendly Waiter" },
      { avatarId: "restaurant_2", fallbackLabel: "Friendly Waitress" },
      { avatarId: "restaurant_3", fallbackLabel: "Welcoming Agent" },
    ],
  },
  {
    id: "directions",
    title: "Asking for directions",
    titleJa: "道を尋ねる",
    level: "Beginner",
    description:
      "You are unfamiliar with the area. Practice asking someone for help, getting directions, and understanding their reply.",
    backgroundImage: "/scenarios/directions.webp",
    characters: [
      { avatarId: "pedestrian_1", fallbackLabel: "Student Passerby" },
      { avatarId: "pedestrian_2", fallbackLabel: "Local Shopkeeper" },
      { avatarId: "pedestrian_3", fallbackLabel: "Friendly Traveler" },
    ],
  },
  {
    id: "convenience-store",
    title: "Market shopping",
    titleJa: "「市場での買い物」",
    level: "Beginner",
    description:
      "Practice a quick market interaction: paying for your items, getting bags, and answering basic questions at the counter.",
    backgroundImage: "/scenarios/store.webp",
    characters: [
      { avatarId: "shopping_1", fallbackLabel: "Daytime Clerk" },
      { avatarId: "shopping_2", fallbackLabel: "Night-shift Clerk" },
      { avatarId: "shopping_3", fallbackLabel: "Noon-shift Clerk" },
    ],
  },
  {
    id: "job-interview",
    title: "Job interview",
    titleJa: "面接",
    level: "Intermediate",
    description:
      "Practice a basic first-round job interview: introduce yourself, explain your strengths, talk about your previous experience, and answer simple follow-up questions.",
    backgroundImage: "/scenarios/interview.webp",
    characters: [
      { avatarId: "interviewer_hr", fallbackLabel: "HR Interviewer" },
      { avatarId: "interviewer_manager", fallbackLabel: "Hiring Manager" },
      { avatarId: "interviewer_assitant", fallbackLabel: "Hiring Assistant" },
    ],
  },
  {
    id: "clinic-appointment",
    title: "Booking a medical appointment",
    titleJa: "病院の予約",
    level: "Intermediate",
    description:
      "Practice contacting a healthcare provider to schedule a visit, explaining your current symptoms, and confirming an available time slot.",
    backgroundImage: "/scenarios/medical.webp",
    characters: [
      { avatarId: "clinic_receptionist", fallbackLabel: "Receptionist" },
      { avatarId: "clinic_nurse", fallbackLabel: "Triage Nurse" },
      { avatarId: "medical_assistant", fallbackLabel: "Medical Assistant" },
    ],
  },
  {
    id: "taxi-rideshare",
    title: "Talking with a Taxi or Cab driver",
    titleJa: "タクシーの運転手との会話",
    level: "Intermediate",
    description:
      "Practice giving directions, making small talk during the ride, and asking the driver about the area.",
    backgroundImage: "/scenarios/taxi.webp",
    characters: [
      { avatarId: "taxi_driver", fallbackLabel: "Taxi Driver" },
      { avatarId: "rideshare_driver", fallbackLabel: "GO Driver" },
      { avatarId: "airport_shuttle_driver", fallbackLabel: "Shuttle Driver" },
    ],
  },
  {
    id: "friend-disagreement",
    title: "Talking through a disagreement with a friend",
    titleJa: "友人との意見の食い違いを話し合う",
    level: "Advanced",
    description:
      "Practice bringing up something that's been bothering you, listening to your friend's side, and working things out together.",
    backgroundImage: "/scenarios/disagreement.webp",
    characters: [
      { avatarId: "friend_close", fallbackLabel: "Close Friend" },
      { avatarId: "friend_roommate", fallbackLabel: "Roommate" },
      { avatarId: "friend_coworker", fallbackLabel: "Coworker Friend" },
    ],
  },
  {
    id: "billing-dispute",
    title: "Talking to customer service about a mistake",
    titleJa: "カスタマーサービスへの問い合わせ",
    level: "Advanced",
    description:
      "Practice calmly explaining a mistake on your bill, asking for it to be fixed, and following up if the first answer doesn't solve it.",
    backgroundImage: "/scenarios/dispute.webp",
    characters: [
      {
        avatarId: "dispute_service_rep",
        fallbackLabel: "Customer Service Rep",
      },
      { avatarId: "dispute_store_manager", fallbackLabel: "Store Manager" },
      { avatarId: "dispute_billing_agent", fallbackLabel: "Billing Agent" },
    ],
  },
  {
    id: "stranger-conversation",
    title: "Striking up a conversation with a stranger",
    titleJa: "見知らぬ人に話しかける",
    level: "Advanced",
    description:
      "No menu, no form — just a stranger nearby and an opening you have to create yourself. Practice reading the room, starting small talk, and keeping it going with no script to fall back on.",
    backgroundImage: "/scenarios/conversation.webp",
    characters: [
      { avatarId: "stranger_commuter", fallbackLabel: "Fellow Commuter" },
      { avatarId: "stranger_cafe_patron", fallbackLabel: "Café Patron" },
      { avatarId: "stranger_line_waiter", fallbackLabel: "Person in Line" },
    ],
  },
];

export function getScenario(id: string): Scenario | undefined {
  return SCENARIOS.find((s) => s.id === id);
}

export function getScenarioCharacter(
  scenarioId: string,
  avatarId: string,
): ScenarioCharacterSlot | undefined {
  const scenario = getScenario(scenarioId);
  return scenario?.characters.find((c) => c.avatarId === avatarId);
}
