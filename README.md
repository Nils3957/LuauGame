# 🎮 LuauGame: Advanced RPG Framework

An extensible and high-performance Roblox game development framework powered by **Luau** and **Rojo**. This project focuses on modular architecture and scalable gameplay systems.

---

## 🚀 Key Features (Current)
- **Advanced Inventory System (v0.0.3):** Programmatic UI rendering with 50+ slots and dynamic information panels.
- **Enhanced Locomotion:** 
  - **Dynamic Double Jump:** Configurable height multipliers (1.5x) for agile movement.
  - **Sprint System:** Smooth transition between walking (16) and sprinting (40/60).
- **Rojo-Native Workflow:** Fully synchronized development environment using external code editors.

---

## 🗺 Roadmap & Future Expansion (Planned)

### 📦 Core Systems (Next Phase)
- **Item Data Synchronization:** Fetching and displaying real-time item information from the database to the Inventory UI.
- **Storage & Vault System:** Implementation of global storage containers for persistence beyond player inventory.

### 🚜 Massive Content Expansion (Long-term)
The following features are planned as major content updates to provide a rich, living-world experience:
- **Agriculture (Farming):** Crop growth cycles, soil management, and harvesting systems.
- **Fishing:** Dynamic water interaction and rarity-based catch mechanics.
- **Mining:** Resource extraction with durability-based tools and node regeneration.
- **Silviculture (Tree Farming):** Strategic forestry and timber processing.
- **Animal Husbandry:** Livestock breeding, feeding, and resource production.

---

## 🛠 Getting Started
1. Clone this repository.
2. Initialize Rojo:
   ```bash
   ./rojo.exe serve
   ```
3. Connect via the Rojo plugin in Roblox Studio.

---

## 📂 Project Structure
- `src/client`: User Interface, Input Handling, and Character Controllers.
- `src/server`: Backend Logic, Database Integration, and Server-side Validation.
- `src/shared`: Reusable modules, Item Databases, and Shared Configurations.

---

## 🇰🇷 프로젝트 가이드 (Korean)

**LuauGame**는 Luau와 Rojo를 기반으로 한 확장 가능한 고성능 로블록스 게임 개발 프레임워크입니다. 모듈형 아키텍처와 확장성 있는 게임플레이 시스템 구축에 집중하고 있습니다.

### 🚀 주요 기능 (현재)
- **고급 인벤토리 시스템 (v0.0.3):** 50개 이상의 슬롯과 동적 정보창을 포함한 프로그래밍 방식의 UI 렌더링.
- **강화된 캐릭터 이동:**
  - **다이내믹 2단 점프:** 기동성 향상을 위한 설정 가능한 점프 배율(1.5배) 적용.
  - **질주 시스템:** 걷기(16)와 달리기(40/60) 사이의 매끄러운 속도 전환.
- **Rojo 기반 워크플로우:** 외부 에디터를 활용한 완전 동기화 개발 환경.

### 🗺 로드맵 및 향후 확장 계획

#### 📦 핵심 시스템 (차기 단계)
- **아이템 데이터 동기화:** 데이터베이스의 실시간 아이템 정보를 인벤토리 UI에 출력 및 연동.
- **보관함(Storage) 시스템:** 인벤토리를 넘어선 영구적 데이터 보관을 위한 글로벌 창고 시스템 구현.

#### 🚜 대규모 콘텐츠 확장 (장기 계획)
살아있는 세계관을 구축하기 위해 다음과 같은 대규모 시스템이 예정되어 있습니다:
- **농사 (Agriculture):** 작물 성장 주기, 토양 관리 및 수확 시스템.
- **낚시 (Fishing):** 역동적인 물 상호작용 및 희귀도 기반 낚시 메커니즘.
- **채광 (Mining):** 도구 내구도 및 자원 재생성이 포함된 광물 채굴 시스템.
- **식목 (Silviculture):** 전략적 임업 및 목재 가공 시스템.
- **목축 (Animal Husbandry):** 가축 번식, 사육 및 자원 생산 시스템.

---

## 📂 프로젝트 구조
- `src/client`: UI, 입력 처리 및 캐릭터 컨트롤러.
- `src/server`: 백엔드 로직, 데이터베이스 연동 및 서버 검증.
- `src/shared`: 재사용 모듈, 아이템 데이터베이스 및 공용 설정.
