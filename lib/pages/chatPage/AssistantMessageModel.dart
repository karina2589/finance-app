class AssistantMessage {
  /*
  {
    "sessionId": "cma0mjxv10009lo2oxm8k296h",
    "assistantMessage": {
        "id": "cma0mni47000jlo2odu2rokcl",
        "createdAt": "2025-04-28T05:18:01.591Z",
        "role": "assistant",
        "content": "Great question! Improving your budgeting skills can make a big difference in your financial health. Here are some tips to help you get started:\n\n**1. Track Your Spending:**  \n- Write down everything you spend for at least a month.\n- Use an app, a spreadsheet, or pen and paper—whatever works best for you.\n\n**2. Set Clear Goals:**  \n- Decide what you want to accomplish with your budget (save for something specific, pay down debt, etc.).\n- Set both short-term and long-term financial goals.\n\n**3. Categorize Expenses:**  \n- Group your spending into categories like rent, groceries, transportation, and entertainment.\n- This helps you see where your money goes and spot areas to cut back.\n\n**4. Use the 50/30/20 Rule:**  \n- 50% for needs (rent, groceries, bills)\n- 30% for wants (eating out, hobbies)\n- 20% for savings and debt repayment\n\n**5. Review & Adjust Regularly:**  \n- Check your budget weekly or monthly.\n- Adjust as your income or expenses change.\n\n**6. Automate Where Possible:**  \n- Set up automatic transfers to savings.\n- Use automatic bill pay to avoid late fees.\n\n**7. Stay Flexible and Be Kind to Yourself:**  \n- Don’t worry if it takes a few tries to get your budget just right.\n- The key is to keep learning and adjusting as you go.\n\nWould you like help setting up a simple budget plan or tracking your spending?",
        "sessionId": "cma0mjxv10009lo2oxm8k296h"
    }
}
   */

  // final String id;
  // final String createdAt;
  final String role;
  final String? content;
  // final String sessionId;

  AssistantMessage({
    // required this.id,
    // required this.createdAt,
    required this.role,
    required this.content,
    // required this.sessionId
  });

  factory AssistantMessage.fromJson(Map<String, dynamic> json){
    return AssistantMessage(
        // id: json['id'],
        // createdAt: json['createdAt'],
        role: json['role'],
        content: json['content']);
        // sessionId: json['sessionId']);
  }
}