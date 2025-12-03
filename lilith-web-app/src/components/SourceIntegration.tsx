import React from 'react';
import { Settings, Code, Package, Flame, Zap, ChevronRight, Menu, X } from 'lucide-react';

interface SourceIntegrationProps {
  config: {
    sourceIntegrationEnabled: boolean;
    sourceDir: string;
    buildDir: string;
  };
  setConfig: React.Dispatch<React.SetStateAction<any>>;
  currentStep: number;
  setCurrentStep: React.Dispatch<React.SetStateAction<number>>;
  steps: Array<{
    title: string;
    icon: string;
    content: string;
  }>;
}

const SourceIntegration: React.FC<SourceIntegrationProps> = ({
  config,
  setConfig,
  currentStep,
  setCurrentStep,
  steps
}) => {
  const renderContent = () => {
    switch(steps[currentStep].content) {
      case 'source-integration':
        return (
          <div className="space-y-6">
            <h2 className="text-2xl font-bold text-gray-800">Deepin Source Code Integration</h2>

            <div className="bg-blue-50 border-l-4 border-blue-400 p-4 mb-6">
              <p className="font-bold text-blue-800 mb-2">Advanced Feature:</p>
              <p className="text-sm text-blue-700">This enables deep source-level modifications of Deepin components with Lilith branding.</p>
            </div>

            <div className="flex items-center gap-3 mb-6">
              <input
                type="checkbox"
                checked={config.sourceIntegrationEnabled}
                onChange={(e) => setConfig({...config, sourceIntegrationEnabled: e.target.checked})}
                className="w-5 h-5 accent-red-700"
              />
              <label className="font-bold text-gray-800">Enable Deepin Source Code Integration</label>
            </div>

            {config.sourceIntegrationEnabled && (
              <div className="space-y-4">
                <div>
                  <label className="block text-sm font-bold text-gray-700 mb-2">Source Directory</label>
                  <input
                    type="text"
                    value={config.sourceDir}
                    onChange={(e) => setConfig({...config, sourceDir: e.target.value})}
                    className="w-full border-2 border-gray-300 rounded px-3 py-2 focus:border-red-700 focus:outline-none"
                    placeholder="/opt/lilith-sources"
                  />
                </div>

                <div>
                  <label className="block text-sm font-bold text-gray-700 mb-2">Build Directory</label>
                  <input
                    type="text"
                    value={config.buildDir}
                    onChange={(e) => setConfig({...config, buildDir: e.target.value})}
                    className="w-full border-2 border-gray-300 rounded px-3 py-2 focus:border-red-700 focus:outline-none"
                    placeholder="/opt/lilith-build"
                  />
                </div>

                <div className="bg-yellow-50 border-l-4 border-yellow-400 p-4">
                  <p className="font-bold text-yellow-800 mb-2">Requirements:</p>
                  <ul className="text-sm text-yellow-700 space-y-1">
                    <li>• Additional 10GB+ disk space</li>
                    <li>• Build tools (cmake, make, gcc)</li>
                    <li>• Development libraries</li>
                    <li>• 30-60 minutes build time</li>
                  </ul>
                </div>
              </div>
            )}

            <div className="bg-gray-100 p-4 rounded border-2 border-gray-300">
              <p className="text-sm text-gray-700 mb-3"><strong>What This Does:</strong></p>
              <ul className="text-sm text-gray-700 space-y-2 list-disc list-inside">
                <li>Clones Deepin source repositories</li>
                <li>Modifies source code to replace Deepin with Lilith</li>
                <li>Removes Chinese language dependencies</li>
                <li>Creates custom Lilith themes</li>
                <li>Builds modified components</li>
                <li>Integrates with ISO build process</li>
              </ul>
            </div>
          </div>
        );

      default:
        return null;
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-900 via-gray-800 to-black">
      {/* Header */}
      <div className="bg-gray-900 border-b-4 border-red-700 sticky top-0 z-50">
        <div className="max-w-6xl mx-auto px-4 py-4 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="text-2xl">🔥</div>
            <div>
              <h1 className="text-2xl font-black text-red-700">LILITH</h1>
              <p className="text-xs text-gray-400">Source Code Integration</p>
            </div>
          </div>
        </div>
      </div>

      <div className="max-w-6xl mx-auto px-4 py-8">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
          {/* Sidebar Navigation */}
          <div className="md:col-span-1">
            <div className="space-y-2">
              {steps.map((step, idx) => (
                <button
                  key={idx}
                  onClick={() => setCurrentStep(idx)}
                  className={`w-full text-left px-4 py-3 rounded-lg font-bold transition ${
                    idx === currentStep
                      ? 'bg-red-700 text-white shadow-lg'
                      : 'bg-gray-700 text-gray-200 hover:bg-gray-600'
                  }`}
                >
                  <span className="mr-2">{step.icon}</span>
                  {step.title}
                  {idx === currentStep && <ChevronRight className="inline float-right mt-1" size={18} />}
                </button>
              ))}
            </div>
          </div>

          {/* Main Content */}
          <div className="md:col-span-3">
            <div className="bg-white rounded-lg shadow-2xl p-8 border-4 border-red-700">
              {renderContent()}

              {/* Navigation Buttons */}
              <div className="flex gap-4 mt-8 pt-6 border-t-2 border-gray-200">
                <button
                  onClick={() => setCurrentStep(Math.max(0, currentStep - 1))}
                  disabled={currentStep === 0}
                  className={`flex-1 py-3 rounded-lg font-bold transition ${
                    currentStep === 0
                      ? 'bg-gray-300 text-gray-500 cursor-not-allowed'
                      : 'bg-gray-400 text-white hover:bg-gray-500'
                  }`}
                >
                  ← Previous
                </button>
                <button
                  onClick={() => setCurrentStep(Math.min(steps.length - 1, currentStep + 1))}
                  disabled={currentStep === steps.length - 1}
                  className={`flex-1 py-3 rounded-lg font-bold transition ${
                    currentStep === steps.length - 1
                      ? 'bg-gray-300 text-gray-500 cursor-not-allowed'
                      : 'bg-red-700 text-white hover:bg-red-800'
                  }`}
                >
                  Next →
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default SourceIntegration;
