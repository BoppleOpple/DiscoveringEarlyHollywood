import { useState } from "react";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "./ui/dialog";
import { Button } from "./ui/button";
import { Input } from "./ui/input";
import { Label } from "./ui/label";
import { Separator } from "./ui/separator";

interface AuthDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
}

export function AuthDialog({ open, onOpenChange }: AuthDialogProps) {
  const [isLogin, setIsLogin] = useState(true);
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [fullName, setFullName] = useState("");

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    // Handle authentication logic here
    console.log(isLogin ? "Login" : "Sign up", { email, password });
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-md bg-[#F5F5F0] border-[#8B0000]">
        <DialogHeader>
          <DialogTitle className="text-center text-[#2C2C2C]">
            {isLogin ? "Welcome Back" : "Join Us"}
          </DialogTitle>
          <p className="text-center text-[#666666] mt-2">
            {isLogin
              ? "Access thousands of copyright documents"
              : "Create an account to explore Early Hollywood"}
          </p>
        </DialogHeader>

        <form onSubmit={handleSubmit} className="space-y-4 mt-4">
          {!isLogin && (
            <div className="space-y-2">
              <Label htmlFor="fullName" className="text-[#2C2C2C]">
                Full Name
              </Label>
              <Input
                id="fullName"
                type="text"
                value={fullName}
                onChange={(e) => setFullName(e.target.value)}
                className="bg-white border-2 border-[#2B6CB0] focus:border-[#8B0000] focus:ring-[#8B0000] rounded-full"
                required={!isLogin}
              />
            </div>
          )}

          <div className="space-y-2">
            <Label htmlFor="email" className="text-[#2C2C2C]">
              Email
            </Label>
            <Input
              id="email"
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="bg-white border-2 border-[#2B6CB0] focus:border-[#8B0000] focus:ring-[#8B0000] rounded-full"
              required
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="password" className="text-[#2C2C2C]">
              Password
            </Label>
            <Input
              id="password"
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="bg-white border-2 border-[#2B6CB0] focus:border-[#8B0000] focus:ring-[#8B0000] rounded-full"
              required
            />
          </div>

          {!isLogin && (
            <div className="space-y-2">
              <Label htmlFor="confirmPassword" className="text-[#2C2C2C]">
                Confirm Password
              </Label>
              <Input
                id="confirmPassword"
                type="password"
                value={confirmPassword}
                onChange={(e) => setConfirmPassword(e.target.value)}
                className="bg-white border-2 border-[#2B6CB0] focus:border-[#8B0000] focus:ring-[#8B0000] rounded-full"
                required={!isLogin}
              />
            </div>
          )}

          {isLogin && (
            <div className="flex justify-end">
              <button
                type="button"
                className="text-[#2B6CB0] hover:text-[#8B0000] transition-colors"
              >
                Forgot password?
              </button>
            </div>
          )}

          <Button
            type="submit"
            className="w-full bg-[#2C2C2C] hover:bg-[#8B0000] text-white transition-colors"
          >
            {isLogin ? "Sign In" : "Create Account"}
          </Button>

          <Separator className="my-4 bg-[#CCCCCC]" />

          <div className="text-center">
            <p className="text-[#666666]">
              {isLogin ? "Don't have an account?" : "Already have an account?"}
              <button
                type="button"
                onClick={() => {
                  setIsLogin(!isLogin);
                  setEmail("");
                  setPassword("");
                  setConfirmPassword("");
                  setFullName("");
                }}
                className="ml-2 text-[#2B6CB0] hover:text-[#8B0000] transition-colors"
              >
                {isLogin ? "Sign up" : "Sign in"}
              </button>
            </p>
          </div>
        </form>
      </DialogContent>
    </Dialog>
  );
}
